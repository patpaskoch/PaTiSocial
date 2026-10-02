-- PaTiSocial: the action library — what a button can do — and the pure rules around it (tests/actions_spec.lua).
-- No WoW API calls here. An action is data: an emote (a WoW emote token, done with DoEmote) or a short predefined chat
-- message (SendChatMessage to SAY, PARTY or RAID). Labels and message texts are locale keys:
--   L["ACTION_" .. key]            short button label, e.g. "Wave"
--   L["ACTION_" .. key .. "_TEXT"] the message of a chat action, e.g. "Thanks!"
-- Adding an action = one line here plus its locale keys. Custom actions (own text/channel) can later use the same
-- shape.
local _, ns = ...
local Actions = {}
ns.Actions = Actions

Actions.NONE = "NONE" -- an empty slot

-- Order = order in the slot dropdown, grouped by category.
Actions.LIST = {
    -- Greeting
    { key = "WAVE", kind = "emote", token = "WAVE", category = "GREETING" },
    { key = "HELLO", kind = "emote", token = "HELLO", category = "GREETING" },
    { key = "BOW", kind = "emote", token = "BOW", category = "GREETING" },
    { key = "SALUTE", kind = "emote", token = "SALUTE", category = "GREETING" },
    { key = "SAY_HELLO", kind = "chat", channel = "SAY", category = "GREETING" },
    -- Positive
    { key = "THANK", kind = "emote", token = "THANK", category = "POSITIVE" },
    { key = "CHEER", kind = "emote", token = "CHEER", category = "POSITIVE" },
    { key = "APPLAUD", kind = "emote", token = "APPLAUD", category = "POSITIVE" },
    { key = "LAUGH", kind = "emote", token = "LAUGH", category = "POSITIVE" },
    { key = "PARTY_THANKS", kind = "chat", channel = "PARTY", category = "POSITIVE" },
    -- Group
    { key = "PARTY_GO", kind = "chat", channel = "PARTY", category = "GROUP" },
    { key = "PARTY_WAIT", kind = "chat", channel = "PARTY", category = "GROUP" },
    { key = "PARTY_STOP", kind = "chat", channel = "PARTY", category = "GROUP" },
    { key = "PARTY_HELP", kind = "chat", channel = "PARTY", category = "GROUP" },
    { key = "PARTY_READY", kind = "chat", channel = "PARTY", category = "GROUP" },
    { key = "RAID_WAIT", kind = "chat", channel = "RAID", category = "GROUP" },
    -- Fun
    { key = "DANCE", kind = "emote", token = "DANCE", category = "FUN" },
    { key = "JOKE", kind = "emote", token = "JOKE", category = "FUN" },
}

local BY_KEY = {}
for _, action in ipairs(Actions.LIST) do BY_KEY[action.key] = action end

-- The action with this key, or nil (unknown, removed or NONE).
function Actions.Get(key)
    return BY_KEY[key]
end

-- Pure: can this client do the action at all? An emote only if its token is in the client's emote list
-- (emoteTokens = { [token] = true }, from the EMOTEn_TOKEN constants) — an unconfirmed emote is not offered.
-- Chat actions always (whether they can be sent right now is Availability).
function Actions.Supported(action, emoteTokens)
    if not action then return false end
    if action.kind == "emote" then return emoteTokens ~= nil and emoteTokens[action.token] == true end
    return action.kind == "chat"
end

-- Pure: why the action cannot be done right now, or nil if it can. state = { inGroup, inRaid }.
-- PARTY needs a group, RAID a raid; never falls back to another channel (no SAY instead of PARTY).
function Actions.Unavailable(action, state)
    if action.kind ~= "chat" then return nil end
    if action.channel == "PARTY" and not state.inGroup then return "NEEDS_GROUP" end
    if action.channel == "RAID" and not state.inRaid then return "NEEDS_RAID" end
    return nil
end

-- Pure: the actions this client supports, in library order (for the slot dropdowns).
function Actions.Choices(emoteTokens)
    local list = {}
    for _, action in ipairs(Actions.LIST) do
        if Actions.Supported(action, emoteTokens) then list[#list + 1] = action end
    end
    return list
end

-- Locale keys of an action: short label, message text (chat only), channel name (chat only).
function Actions.LabelKey(action) return "ACTION_" .. action.key end
function Actions.TextKey(action) return action.kind == "chat" and ("ACTION_" .. action.key .. "_TEXT") or nil end
function Actions.ChannelKey(action) return action.kind == "chat" and ("CHANNEL_" .. action.channel) or nil end
