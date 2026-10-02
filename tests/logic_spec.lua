-- PaTiSocial settings, slots and layout. Run via PaTiAdmin/tools/check.sh.
local wow = require("wow_api")

local function load()
    return wow.loadAddonFile("Logic.lua", {}).Logic
end

local KNOWN = { WAVE = true, THANK = true, LAUGH = true, PARTY_GO = true, PARTY_WAIT = true, CHEER = true, DANCE = true }
local function isKnown(key) return KNOWN[key] == true end

describe("Logic.Migrate / RestoreDefaults", function()
    it("a new character gets horizontal, 6 buttons, expanded, and the six default actions", function()
        local db = load().Migrate(nil, isKnown)
        assert.same({ "horizontal", 6, false, 1, 0.75, 1 }, { db.layout, db.slotCount, db.collapsed, db.scale,
            db.opacity, db.schema })
        assert.same({ "WAVE", "THANK", "LAUGH", "PARTY_GO", "PARTY_WAIT", "CHEER", "NONE", "NONE", "NONE", "NONE",
            "NONE", "NONE" }, db.slots)
    end)

    it("keeps saved values (also false), the position and the slots", function()
        local db = load().Migrate({ locked = true, collapsed = true, layout = "vertical", slotCount = 4, scale = 1.25,
            point = "TOPLEFT", x = 5, slots = { "DANCE", "NONE", "WAVE" } }, isKnown)
        assert.same({ true, true, "vertical", 4, 1.25, "TOPLEFT", 5 }, { db.locked, db.collapsed, db.layout,
            db.slotCount, db.scale, db.point, db.x })
        assert.same({ "DANCE", "NONE", "WAVE", "NONE" }, { db.slots[1], db.slots[2], db.slots[3], db.slots[4] })
        assert.equal(12, #db.slots)
    end)

    it("repairs broken values: unknown layout or count, removed or non-string actions become defaults / NONE", function()
        local Logic = load()
        local db = Logic.Migrate({ layout = "diagonal", slotCount = 7, slots = { "GONE_ACTION", 42, "WAVE" } }, isKnown)
        assert.same({ "horizontal", 6 }, { db.layout, db.slotCount })
        assert.same({ "NONE", "NONE", "WAVE" }, { db.slots[1], db.slots[2], db.slots[3] })
        assert.equal("NONE", Logic.Migrate({ slots = "broken" }).slots[12])
        assert.equal("WAVE", Logic.Migrate({ slots = "broken" }).slots[1]) -- not a table: the defaults
    end)

    it("Restore Defaults: settings and slots back, position kept", function()
        local db = load().RestoreDefaults({ layout = "vertical", slotCount = 12, collapsed = true, point = "TOP", x = 3,
            slots = { "DANCE" } })
        assert.same({ "horizontal", 6, false, "TOP", 3 }, { db.layout, db.slotCount, db.collapsed, db.point, db.x })
        assert.equal("WAVE", db.slots[1])
        assert.equal(12, #db.slots)
    end)
end)

describe("Logic.VisibleSlots", function()
    it("shows the first slotCount slots, leaves out empty ones, keeps slot order", function()
        local Logic = load()
        local db = Logic.Migrate({ slotCount = 4, slots = { "WAVE", "NONE", "LAUGH", "DANCE", "THANK" } }, isKnown)
        assert.same({ { slot = 1, key = "WAVE" }, { slot = 3, key = "LAUGH" }, { slot = 4, key = "DANCE" } },
            Logic.VisibleSlots(db))
        db.slotCount = 6
        assert.equal(4, #Logic.VisibleSlots(db))
    end)

    it("leaves out actions this client cannot do", function()
        local Logic = load()
        local db = Logic.Migrate({ slotCount = 4, slots = { "WAVE", "DANCE", "LAUGH", "THANK" } }, isKnown)
        local list = Logic.VisibleSlots(db, function(key) return key ~= "DANCE" end)
        assert.same({ "WAVE", "LAUGH", "THANK" }, { list[1].key, list[2].key, list[3].key })
    end)
end)

describe("Logic.Arrange", function()
    it("horizontal: side by side, wraps only before maxWidth; vertical: one per line", function()
        local Logic = load()
        local points, width, height = Logic.Arrange({ 60, 70, 80 }, "horizontal", 26, 4, 1000)
        assert.same({ { x = 0, y = 0 }, { x = 64, y = 0 }, { x = 138, y = 0 } }, points)
        assert.same({ 218, 26 }, { width, height })
        points, width, height = Logic.Arrange({ 60, 70, 80 }, "horizontal", 26, 4, 150)
        assert.same({ x = 0, y = 26 }, points[3])
        assert.same({ 134, 52 }, { width, height })
        points, width, height = Logic.Arrange({ 60, 70, 80 }, "vertical", 26, 4, 1000)
        assert.same({ { x = 0, y = 0 }, { x = 0, y = 26 }, { x = 0, y = 52 } }, points)
        assert.same({ 80, 78 }, { width, height })
    end)
end)
