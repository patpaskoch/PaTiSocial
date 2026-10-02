# Changelog

Format: `## [Unreleased]` / `## [x.y.z] - YYYY-MM-DD` with Added, Changed, Fixed, Removed, Known Issues.

## [Unreleased] — 0.1.0
### Added
- New addon "Party Social" (owner wish 2026-10-02): a panel of up to 12 buttons (4/6/8/10/12 shown), each with one
  action or none. One click = exactly one emote or one message; nothing automatic.
- Action library (`Actions.lua`): emotes WAVE, HELLO, BOW, SALUTE, THANK, CHEER, APPLAUD, LAUGH, DANCE, JOKE via
  `DoEmote` — offered only if the token is in the client's own emote list (`EMOTEn_TOKEN`); predefined messages via
  `SendChatMessage` to SAY (hello), PARTY (thanks, go, wait, stop, help, ready) and RAID (wait). PARTY only in a
  group, RAID only in a raid (button greyed out, reason in the tooltip); never another channel instead.
- Layout horizontal (compact row, wraps only when the screen is too narrow) or vertical; Collapse/Expand; panel
  opacity; registered for the optional PaTiSuite control panel.
- Settings: language, scale, lock, opacity, layout, number of buttons, the action of each button.
- `PaTiSocialDB`, schema 1: position, locked, collapsed, scale, language, opacity, layout, slotCount, slots (12 keys,
  NONE = empty); unknown or broken values are repaired on login. Restore Defaults keeps the position.
- `/psocial`, `/patisocial` with show, hide, lock, unlock, reset, settings, debug, version. English texts, German
  translation. MIT license.
### Known Issues
- Not tested in game yet (`INGAME_TESTING.md`). The Forever client's emote list, `DoEmote` and `SendChatMessage`
  behaviour (SAY needs a hardware event in modern clients — a click is one) are unconfirmed.
- No icon in the AddOns list yet; buttons show text.
