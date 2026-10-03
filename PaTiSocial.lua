-- PaTiSocial ("Party Social"): a small panel of quick emote and chat buttons. One click = exactly one emote or one
-- message, never by itself (no auto-replies, no chains, no timers). No secure frames: DoEmote and SendChatMessage are
-- called from the button click (a hardware event, which SAY needs in modern clients). docs/WOW_API_COMPAT.md.
local addonName, ns = ...
local UI, L, Logic, Actions = ns.UI, ns.UI.L, ns.Logic, ns.Actions

local DB
local emoteTokens = {} -- { [token] = true } from the client's EMOTEn_TOKEN constants (read at login)
local emoteIndexCount = 0

local function say(key, ...)
    print("|cff68caffPaTiSocial:|r " .. L[key]:format(...))
end

local function isSecret(value) return issecretvalue ~= nil and issecretvalue(value) == true end

local function addonVersion()
    local getMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    return getMetadata and getMetadata(addonName, "Version") or "?"
end

-- API adapters ---------------------------------------------------------------------------------------------------

-- The emotes this client knows: WoW's own EMOTEn_TOKEN constants (the list the chat uses for /wave etc.).
local MAX_EMOTE_SCAN = 1000 -- if MAXEMOTEINDEX is missing
local function readEmoteTokens()
    local tokens, count = {}, 0
    local max = tonumber(_G.MAXEMOTEINDEX) or MAX_EMOTE_SCAN
    for index = 1, max do
        local token = _G["EMOTE" .. index .. "_TOKEN"]
        if type(token) == "string" and not isSecret(token) then
            tokens[token] = true
            count = count + 1
        end
    end
    return tokens, count
end

local function flag(value) return not isSecret(value) and (value == true or value == 1) end

local function groupState()
    return { inGroup = IsInGroup ~= nil and flag(IsInGroup()), inRaid = IsInRaid ~= nil and flag(IsInRaid()) }
end

local function usable(key) return Actions.Supported(Actions.Get(key), emoteTokens) end

-- Exactly one emote or one message for one click. Re-checks the channel rule at click time.
local function perform(action)
    if Actions.Unavailable(action, groupState()) then return end
    local ok, err
    if action.kind == "emote" then
        if not DoEmote then return end
        ok, err = pcall(DoEmote, action.token)
    elseif SendChatMessage then
        ok, err = pcall(SendChatMessage, L[Actions.TextKey(action)], action.channel)
    else
        return
    end
    if not ok then say("ACTION_FAILED", tostring(err)) end
end

-- Window ---------------------------------------------------------------------------------------------------------

local PAD, GAP = UI.Spacing.MD, UI.Spacing.SM
local LINE = UI.Sizes.ButtonHeight + GAP
local window = UI.CreateWindow("PaTiSocialFrame", "Party Social", 160, 60)
window:SetCombatMovable(true) -- no secure children: may be dragged in combat too (PaTiShared)
local content = CreateFrame("Frame", nil, window) -- everything below the header; hidden while collapsed
content:SetPoint("TOPLEFT", 0, -UI.Sizes.HeaderHeight)
content:SetPoint("BOTTOMRIGHT")
local empty = content:CreateFontString(nil, "OVERLAY", UI.Fonts.Muted)
empty:SetPoint("TOPLEFT", PAD, -GAP)
empty:SetJustifyH("LEFT")
empty:SetWordWrap(true)
local EMPTY_WIDTH = 180 -- the "no actions" hint wraps inside this width

local function tooltipFor(button)
    local action = button.action
    if not action then return nil end
    local lines = { L[Actions.LabelKey(action)] }
    if action.kind == "emote" then
        lines[#lines + 1] = L.KIND_EMOTE
    else
        lines[#lines + 1] = L[Actions.ChannelKey(action)]
        lines[#lines + 1] = L.QUOTED:format(L[Actions.TextKey(action)])
    end
    local reason = Actions.Unavailable(action, groupState())
    lines[#lines + 1] = reason and L["REASON_" .. reason] or L.CLICK_TO_DO
    return lines
end

local buttons = {}
local function buttonAt(index)
    if buttons[index] then return buttons[index] end
    local button = UI.CreateButton(content, nil, nil, function(self) if self.action then perform(self.action) end end)
    UI.SetTooltip(button, function() return tooltipFor(button) end)
    buttons[index] = button
    return button
end

-- Header needs: title, gap, ••• button (as UI.CreateWindow places them).
local function headerWidth()
    return UI.Spacing.MD + math.ceil(UI.TextWidth(window.title)) + UI.Spacing.LG + UI.Sizes.HeaderHeight
        + UI.Spacing.XS
end

local function maxRowWidth()
    local screen = UIParent:GetWidth() * UIParent:GetEffectiveScale() / window:GetEffectiveScale()
    return screen * Logic.SCREEN_SHARE - 2 * PAD
end

-- Buttons for the visible slots, laid out horizontally (compact, side by side) or vertically (one per line, all
-- as wide as the widest); collapsed = header only.
local function refresh()
    if not DB then return end
    local visible = Logic.VisibleSlots(DB, usable)
    local state = groupState()
    local widths = {}
    for index, slot in ipairs(visible) do
        local button, action = buttonAt(index), Actions.Get(slot.key)
        button.action = action
        UI.BindText(button.label, function() return L[Actions.LabelKey(action)] end)
        button:SetEnabled(Actions.Unavailable(action, state) == nil)
        widths[index] = button:GetWidth()
        button:Show()
    end
    for index = #visible + 1, #buttons do buttons[index].action = nil; buttons[index]:Hide() end
    local points, usedWidth, usedHeight = Logic.Arrange(widths, DB.layout, LINE, GAP, maxRowWidth())
    empty:SetText(#visible == 0 and L.NO_ACTIONS or "")
    empty:SetShown(#visible == 0)
    if #visible == 0 then usedWidth, usedHeight = EMPTY_WIDTH, 2 * LINE end
    local inner = math.max(usedWidth, headerWidth() - 2 * PAD)
    empty:SetWidth(inner)
    for index, point in ipairs(points) do
        local button = buttons[index]
        if DB.layout == "vertical" then button:SetWidth(inner) end
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", content, "TOPLEFT", PAD + point.x, -(GAP + point.y))
    end
    window:SetWidth(inner + 2 * PAD)
    content:SetShown(not DB.collapsed)
    window:SetHeight(UI.Sizes.HeaderHeight + (DB.collapsed and 0 or GAP + usedHeight + PAD - GAP))
end

-- Settings -------------------------------------------------------------------------------------------------------

local modal

local function kindName(action)
    if action.kind == "emote" then return L.KIND_EMOTE end
    return L["CHANNEL_SHORT_" .. action.channel]
end

local function slotItems()
    local items = { { value = Logic.NONE, text = function() return L.ACTION_NONE end } }
    for _, action in ipairs(Actions.Choices(emoteTokens)) do
        items[#items + 1] = { value = action.key,
            text = function() return L[Actions.LabelKey(action)] .. " · " .. kindName(action) end }
    end
    return items
end

local function buildSettings()
    modal = UI.CreateModal("PaTiSocialSettings", function() return "Party Social " .. L.SETTINGS end, 380)
    local scales, layouts, counts = {}, {}, {}
    for _, scale in ipairs(Logic.SCALES) do
        scales[#scales + 1] = { value = scale, text = function() return ("%d %%"):format(scale * 100 + 0.5) end }
    end
    for _, layout in ipairs(Logic.LAYOUTS) do
        layouts[#layouts + 1] = { value = layout, text = function() return L[layout:upper()] end }
    end
    for _, count in ipairs(Logic.SLOT_COUNTS) do
        counts[#counts + 1] = { value = count, text = function() return tostring(count) end }
    end
    modal:AddSection("GENERAL")
    modal:AddRow("LANGUAGE", UI.CreateLanguageDropdown(modal, DB, 170))
    modal:AddRow("SCALE", UI.CreateDropdown(modal, 170, {
        items = function() return scales end,
        get = function() return DB.scale end,
        set = function(scale) DB.scale = scale; window:SetScale(scale) end, -- no secure frames: fine in combat
    }))
    modal:AddControls(UI.CreateCheckbox(modal, "LOCK_WINDOW", {
        get = function() return window:IsLocked() end,
        set = function(locked) window:SetLocked(locked) end,
    }))
    UI.AddWindowSettings(modal, window)
    modal:AddSection("DISPLAY")
    modal:AddRow("LAYOUT", UI.CreateDropdown(modal, 170, {
        items = function() return layouts end,
        get = function() return DB.layout end,
        set = function(layout) DB.layout = layout; refresh() end,
    }))
    modal:AddRow("SLOT_COUNT", UI.CreateDropdown(modal, 170, {
        items = function() return counts end,
        get = function() return DB.slotCount end,
        set = function(count) DB.slotCount = count; refresh() end,
    }))
    modal:AddSection("SLOTS")
    for index = 1, Logic.MAX_SLOTS do
        modal:AddRow(function() return L.SLOT_N:format(index) end, UI.CreateDropdown(modal, 200, {
            items = slotItems,
            get = function() return DB.slots[index] end,
            set = function(key) DB.slots[index] = key; refresh() end,
        }))
    end
    modal:Finish(function()
        Logic.RestoreDefaults(DB)
        window:ApplyTheme() -- Restore Defaults: theme back to default
        window:ApplyOpacity()
        UI.SetLanguage(DB.language)
        window:SetLocked(DB.locked)
        window:SetScale(DB.scale)
        refresh()
    end)
end

local function openSettings()
    if not modal then buildSettings() end
    modal:Show()
end

-- Commands -------------------------------------------------------------------------------------------------------

local function toggleCollapsed() -- no secure frames: fine in combat
    DB.collapsed = not DB.collapsed
    refresh()
end

local function setShown(shown, quiet)
    window:SetShown(shown)
    if not shown and not quiet then say("HIDDEN_HINT") end
    return true
end

-- Optional PaTiSuite control panel: the same rules as the commands, without chat lines.
window.suiteSetShown = function(shown) return setShown(shown, true) end

local function resetPosition()
    DB.point, DB.relativePoint, DB.x, DB.y = nil, nil, nil, nil
    window:Attach(DB, 0, -200)
end

local function printDebug()
    local version, build, _, interface = GetBuildInfo()
    local state = groupState()
    local supported, unsupported = {}, {}
    for _, action in ipairs(Actions.LIST) do
        local list = Actions.Supported(action, emoteTokens) and supported or unsupported
        list[#list + 1] = action.key
    end
    print("|cff68caffPaTiSocial Debug:|r")
    for _, line in ipairs({
        ("Addon %s %s · PaTiShared UI %s"):format(addonName, addonVersion(), tostring(UI.VERSION)),
        ("WoW %s (build %s, interface %s) · locale %s · UI language %s"):format(tostring(version), tostring(build),
            tostring(interface), GetLocale(), UI.GetLanguage()),
        ("APIs: DoEmote %s · SendChatMessage %s · MAXEMOTEINDEX %s · emote tokens found %d"):format(
            DoEmote and "yes" or "no", SendChatMessage and "yes" or "no", tostring(_G.MAXEMOTEINDEX), emoteIndexCount),
        ("Group %s · raid %s · layout %s · slots %d"):format(tostring(state.inGroup), tostring(state.inRaid),
            DB.layout, DB.slotCount),
        "Offered: " .. (#supported > 0 and table.concat(supported, ", ") or "none"),
        "Not offered (emote unknown to this client): "
            .. (#unsupported > 0 and table.concat(unsupported, ", ") or "none"),
    }) do print("  " .. line) end
end

local COMMANDS = {
    [""] = function() setShown(not window:IsShown()) end,
    show = function() setShown(true) end,
    hide = function() setShown(false) end,
    lock = function() window:SetLocked(true) end,
    unlock = function() window:SetLocked(false) end,
    reset = resetPosition,
    settings = openSettings,
    debug = printDebug,
    version = function() say("VERSION", addonVersion()) end,
}

SLASH_PATISOCIAL1 = "/patisocial"
SLASH_PATISOCIAL2 = "/psocial"
SlashCmdList.PATISOCIAL = function(message)
    local command = COMMANDS[(message or ""):match("^%s*(.-)%s*$"):lower()]
    if command and DB then command() else say("HELP") end
end

window:SetMenu(function()
    if not DB then return {} end
    return {
        { text = "SETTINGS", onClick = openSettings },
        { text = window:IsLocked() and "UNLOCK" or "LOCK",
            onClick = function() window:SetLocked(not window:IsLocked()) end },
        { text = DB.collapsed and "EXPAND" or "COLLAPSE", onClick = toggleCollapsed },
        { text = "HIDE", onClick = function() setShown(false) end },
    }
end)

-- Events: login, and group changes (PARTY/RAID buttons switch between usable and greyed out) ----------------------

local events = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "GROUP_ROSTER_UPDATE" }) do
    events:RegisterEvent(event)
end

events:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        emoteTokens, emoteIndexCount = readEmoteTokens()
        PaTiSocialDB = Logic.Migrate(PaTiSocialDB, function(key) return Actions.Get(key) ~= nil end)
        DB = PaTiSocialDB
        UI.SetLanguage(DB.language)
        window:Attach(DB, 0, -200)
        window:SetScale(DB.scale)
    end
    refresh()
end)
UI.OnLanguageChanged(refresh)
UI.OnThemeChanged(refresh) -- state colours follow the theme (static ones repaint themselves, UI.Paint)
