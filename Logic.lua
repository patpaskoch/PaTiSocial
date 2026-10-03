-- PaTiSocial: saved settings, slots and layout — no WoW API calls (tests/logic_spec.lua).
local _, ns = ...
local Logic = {}
ns.Logic = Logic

Logic.SCHEMA = 1
Logic.SCALES = { 0.8, 0.9, 1, 1.1, 1.25, 1.5 }
Logic.LAYOUTS = { "horizontal", "vertical" }
Logic.SLOT_COUNTS = { 4, 6, 8, 10, 12 }
Logic.MAX_SLOTS = 12
Logic.NONE = "NONE"
-- Horizontal: the row may use this share of the screen width before it wraps (PaTiSocial.lua computes the px).
Logic.SCREEN_SHARE = 0.9

-- First start: six slots that work solo and in a group (owner's example 2026-10-02: wave, thanks, laugh, go, wait,
-- cheer). The rest is empty.
Logic.DEFAULT_SLOTS = { "WAVE", "THANK", "LAUGH", "PARTY_GO", "PARTY_WAIT", "CHEER" }

-- Position (point, relativePoint, x, y) is written by the PaTiShared window, not listed here.
Logic.DEFAULTS = {
    opacity = 0.75,
    theme = "default", -- "default" | "woforever" | "dracula" (PaTiShared UI.THEMES; colours only)
    locked = false,
    collapsed = false,
    scale = 1,
    language = "auto",
    layout = "horizontal",
    slotCount = 6,
}

local function listed(list, value)
    for _, known in ipairs(list) do
        if known == value then return true end
    end
    return false
end

local function defaultSlots()
    local slots = {}
    for index = 1, Logic.MAX_SLOTS do slots[index] = Logic.DEFAULT_SLOTS[index] or Logic.NONE end
    return slots
end

-- Fills missing values and keeps every saved one (also false). slots = exactly MAX_SLOTS action keys: anything that
-- is not a string, or (with isKnown) not a known action any more, becomes NONE. An unknown layout or slot count
-- falls back to the default.
function Logic.Migrate(db, isKnown)
    if type(db) ~= "table" then db = {} end -- nil or a broken save (string, number …): start fresh
    for key, value in pairs(Logic.DEFAULTS) do
        if db[key] == nil then db[key] = value end
    end
    -- A broken scale would make SetScale fail on login: only a sane number is kept (saved values elsewhere stay).
    if type(db.scale) ~= "number" or db.scale < 0.5 or db.scale > 2 then db.scale = Logic.DEFAULTS.scale end
    -- Theme: one of the three PaTiShared themes; a typo or an old value falls back to the default look.
    if db.theme ~= "default" and db.theme ~= "woforever" and db.theme ~= "dracula" then db.theme = "default" end
    if not listed(Logic.LAYOUTS, db.layout) then db.layout = Logic.DEFAULTS.layout end
    if not listed(Logic.SLOT_COUNTS, db.slotCount) then db.slotCount = Logic.DEFAULTS.slotCount end
    local saved = type(db.slots) == "table" and db.slots or defaultSlots()
    local slots = {}
    for index = 1, Logic.MAX_SLOTS do
        local key = saved[index]
        local valid = type(key) == "string" and (key == Logic.NONE or not isKnown or isKnown(key))
        slots[index] = valid and key or Logic.NONE
    end
    db.slots = slots
    db.schema = Logic.SCHEMA
    return db
end

-- "Restore Defaults": settings and slots back, position kept.
function Logic.RestoreDefaults(db)
    for key, value in pairs(Logic.DEFAULTS) do db[key] = value end
    db.slots = defaultSlots()
    return db
end

-- Pure: the buttons to show — the first slotCount slots, empty ones left out, in slot order.
-- Returns { { slot = n, key = "WAVE" }, … }. isUsable(key) (optional) leaves out actions this client cannot do.
function Logic.VisibleSlots(db, isUsable)
    local list = {}
    for index = 1, math.min(db.slotCount or 0, Logic.MAX_SLOTS) do
        local key = db.slots and db.slots[index]
        if type(key) == "string" and key ~= Logic.NONE and (not isUsable or isUsable(key)) then
            list[#list + 1] = { slot = index, key = key }
        end
    end
    return list
end

-- Pure: where each button goes. "vertical": one per line; "horizontal": side by side with `gap`, a new line only
-- when the next one would pass maxWidth. Returns positions { { x, y }, … }, used width and height.
-- (The same small flow as PaTiSuite's Logic.Arrange — copied on purpose, addons stay independent.)
function Logic.Arrange(widths, layout, lineHeight, gap, maxWidth)
    local points, x, y, width = {}, 0, 0, 0
    for index, entryWidth in ipairs(widths) do
        if layout == "horizontal" then
            if x > 0 and x + entryWidth > maxWidth then x, y = 0, y + lineHeight end
            points[index] = { x = x, y = y }
            width = math.max(width, x + entryWidth)
            x = x + entryWidth + gap
        else
            points[index] = { x = 0, y = (index - 1) * lineHeight }
            width = math.max(width, entryWidth)
        end
    end
    if #widths == 0 then return points, 0, 0 end
    local height = layout == "horizontal" and y + lineHeight or #widths * lineHeight
    return points, width, height
end
