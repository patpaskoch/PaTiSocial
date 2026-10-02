-- PaTiSocial action library: support, channels and labels. Run via PaTiAdmin/tools/check.sh.
local wow = require("wow_api")

local function load()
    return wow.loadAddonFile("Actions.lua", {}).Actions
end

describe("Actions library", function()
    it("knows its actions by key; unknown keys and NONE are nil", function()
        local Actions = load()
        assert.same({ "emote", "WAVE" }, { Actions.Get("WAVE").kind, Actions.Get("WAVE").token })
        assert.same({ "chat", "PARTY" }, { Actions.Get("PARTY_GO").kind, Actions.Get("PARTY_GO").channel })
        assert.is_nil(Actions.Get("NOPE"))
        assert.is_nil(Actions.Get(Actions.NONE))
    end)

    it("every action has a unique key and a kind; emotes a token, chat a SAY/PARTY/RAID channel", function()
        local Actions, seen = load(), {}
        local CHANNELS = { SAY = true, PARTY = true, RAID = true }
        for _, action in ipairs(Actions.LIST) do
            assert.is_nil(seen[action.key])
            seen[action.key] = true
            if action.kind == "emote" then
                assert.equal("string", type(action.token))
            else
                assert.equal("chat", action.kind)
                assert.is_true(CHANNELS[action.channel] == true)
            end
        end
    end)

    it("label, text and channel keys", function()
        local Actions = load()
        local wave, go = Actions.Get("WAVE"), Actions.Get("PARTY_GO")
        assert.equal("ACTION_WAVE", Actions.LabelKey(wave))
        assert.is_nil(Actions.TextKey(wave))
        assert.is_nil(Actions.ChannelKey(wave))
        assert.same({ "ACTION_PARTY_GO", "ACTION_PARTY_GO_TEXT", "CHANNEL_PARTY" },
            { Actions.LabelKey(go), Actions.TextKey(go), Actions.ChannelKey(go) })
    end)

    it("an emote is offered only if the client lists its token; chat actions always", function()
        local Actions = load()
        local tokens = { WAVE = true, THANK = true }
        assert.is_true(Actions.Supported(Actions.Get("WAVE"), tokens))
        assert.is_false(Actions.Supported(Actions.Get("DANCE"), tokens))
        assert.is_false(Actions.Supported(Actions.Get("WAVE"), nil))
        assert.is_true(Actions.Supported(Actions.Get("PARTY_GO"), {}))
        assert.is_false(Actions.Supported(nil, tokens))
        local keys = {}
        for _, action in ipairs(Actions.Choices(tokens)) do keys[action.key] = true end
        assert.is_true(keys.WAVE and keys.THANK and keys.PARTY_GO)
        assert.is_nil(keys.DANCE)
    end)
end)

describe("Actions.Unavailable (chat channel rules)", function()
    local SOLO = { inGroup = false, inRaid = false }
    local PARTY = { inGroup = true, inRaid = false }
    local RAID = { inGroup = true, inRaid = true }

    it("PARTY only in a group, never falling back to SAY", function()
        local Actions = load()
        assert.equal("NEEDS_GROUP", Actions.Unavailable(Actions.Get("PARTY_GO"), SOLO))
        assert.is_nil(Actions.Unavailable(Actions.Get("PARTY_GO"), PARTY))
        assert.is_nil(Actions.Unavailable(Actions.Get("PARTY_GO"), RAID))
    end)

    it("RAID only in a raid; SAY and emotes always", function()
        local Actions = load()
        assert.equal("NEEDS_RAID", Actions.Unavailable(Actions.Get("RAID_WAIT"), PARTY))
        assert.equal("NEEDS_RAID", Actions.Unavailable(Actions.Get("RAID_WAIT"), SOLO))
        assert.is_nil(Actions.Unavailable(Actions.Get("RAID_WAIT"), RAID))
        assert.is_nil(Actions.Unavailable(Actions.Get("SAY_HELLO"), SOLO))
        assert.is_nil(Actions.Unavailable(Actions.Get("WAVE"), SOLO))
    end)
end)

describe("Locales", function()
    it("every action has a label and every chat action its message, in enUS and deDE", function()
        local Actions = load()
        local en = wow.loadAddonFile("Locales/enUS.lua", {}).Locales.enUS
        local de = wow.loadAddonFile("Locales/deDE.lua", {}).Locales.deDE
        for _, action in ipairs(Actions.LIST) do
            assert.equal("string", type(en[Actions.LabelKey(action)]))
            assert.equal("string", type(de[Actions.LabelKey(action)]))
            if action.kind == "chat" then
                assert.equal("string", type(en[Actions.TextKey(action)]))
                assert.equal("string", type(de[Actions.TextKey(action)]))
                assert.equal("string", type(en[Actions.ChannelKey(action)]))
                assert.equal("string", type(en["CHANNEL_SHORT_" .. action.channel]))
            end
        end
    end)
end)
