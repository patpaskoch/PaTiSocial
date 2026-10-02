# AGENTS.md — PaTiSocial

**Read the suite rules first: [`../../PaTiAdmin/AGENTS.md`](../../PaTiAdmin/AGENTS.md).** They apply here in full.
Addon facts: `../../PaTiAdmin/docs/ARCHITECTURE.md` · open issues: `../../PaTiAdmin/docs/FOLLOW_UPS.md`.

## This addon
- Purpose: "Party Social" — quick emote and message buttons. **One click = exactly one action.** Never: automatic
  messages, replies, greetings, chains, timers, whispers, situation-based chat or macros.
- Files: `Actions.lua` (action library + pure rules: Supported, Unavailable, Choices; tested) · `Logic.lua` (settings,
  migration, visible slots, layout; pure, tested) · `PaTiSocial.lua` (adapters `readEmoteTokens`, `groupState`,
  `perform`; window, settings, commands, events) · `Locales/` · `Shared/` (PaTiShared, synced — never edit).
- New action = one line in `Actions.LIST` + `ACTION_<KEY>` (and `_TEXT` for chat) in enUS/deDE. Emotes only with a
  token the client lists (`EMOTEn_TOKEN`); chat only SAY/PARTY/RAID with the channel rule in `Actions.Unavailable`
  (no fallback to another channel).
- SavedVariables: `PaTiSocialDB` (per character), schema 1 — see `Logic.DEFAULTS`; `slots` = 12 action keys, `NONE`
  = empty. Any shape change: bump `Logic.SCHEMA`, add a migration step and a test.
- Secure / combat-sensitive: none. `DoEmote` / `SendChatMessage` only inside a button's click (hardware event).
- Slash commands: `/psocial`, `/patisocial`. No test mode (it would show nothing the real window does not).

## Checks
`bash ../../PaTiAdmin/tools/check.sh .` before every commit. Manual WoW tests: `INGAME_TESTING.md`.
