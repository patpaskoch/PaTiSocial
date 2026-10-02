# PaTiSocial

<img src="assets/icon-128.png" width="96" alt="PaTiSocial icon">

A small quick-communication panel for World of Warcraft: Forever (Interface 16001). In game the window is called
**Party Social**: a row of buttons for emotes and short messages. One click = exactly one emote or one message —
PaTiSocial never says or does anything by itself.

> Status: 0.1.0, in development, not yet released. Not yet tested in game.

## Features
- Up to 12 buttons (4, 6, 8, 10 or 12 shown); every button can hold any action, or none
- **Emotes:** wave, hello, bow, salute, thanks, cheer, applaud, laugh, dance, joke — only those your client knows
  (PaTiSocial checks the client's own emote list; `/psocial debug` shows which ones)
- **Short messages:** "Hello!" (say); "Thanks!", "Let's go!", "Wait a moment, please.", "Stop.", "Help!", "Ready."
  (party); "Wait a moment, please." (raid). A party message works only in a group, a raid message only in a raid —
  otherwise the button is greyed out and says why. It never switches to another channel by itself
- Layout: horizontal (compact row) or vertical (one button per line)
- Tooltips: what the button does — emote, or which channel and the exact message
- ••• menu: Settings, Lock, Collapse/Expand, Hide. Settings: language, scale, lock, panel opacity, layout, number of
  buttons, the action of each button. Languages: English, Deutsch (others fall back to English)

Default buttons: Wave, Thanks, Laugh, Go! (party), Wait (party), Cheer.

## PaTiSuite

This addon is part of the **PaTiSuite** — a collection of small addons for World of Warcraft: Forever.
Each one is installed on its own and works on its own; none of them is needed by another.

- [PaTiSuite](https://github.com/patpaskoch/PaTiSuite) – optional control panel to show and hide the PaTi windows
- [PaTiHeal](https://github.com/patpaskoch/PaTiHeal) – healer party frames and click casting
- [PaTiAuras](https://github.com/patpaskoch/PaTiAuras) – buff, aura and proc watcher
- [PaTiTank](https://github.com/patpaskoch/PaTiTank) – tank HUD and aggro monitor
- [PaTiGroup](https://github.com/patpaskoch/PaTiGroup) – raid markers, ready check and pull timer
- [PaTiQuest](https://github.com/patpaskoch/PaTiQuest) – selected quest and its objectives
- [PaTiDungeon](https://github.com/patpaskoch/PaTiDungeon) – instance, group and combat status
- **PaTiSocial** – "Party Social": quick emote and message buttons *(this addon)*
- [PaTiAlerts](https://github.com/patpaskoch/PaTiAlerts) – one window for open problems

### Goes well with (optional)

- [PaTiGroup](https://github.com/patpaskoch/PaTiGroup) – the other half of group play: markers, ready check, pull timer
- [PaTiSuite](https://github.com/patpaskoch/PaTiSuite) – shows and hides this window together with the other PaTi windows

## Installation
1. Download the release zip (`PaTiSocial-<version>.zip`).
2. Unpack it and copy the folder `PaTiSocial` into `World of Warcraft/<client>/Interface/AddOns/`.
3. Start WoW and enable PaTiSocial in the AddOns list.

## First steps
- `/psocial` shows or hides the window; drag it by its header
- `/psocial settings` → choose the layout, how many buttons, and what each button does

## Commands
`/psocial` or `/patisocial` — alone: show/hide · `show` · `hide` · `lock` · `unlock` · `reset` (position) ·
`settings` · `debug` · `version`

## Known limitations
- Not yet tested in game; whether the Forever client's emote list and chat API behave as expected is unconfirmed.
- Only the predefined actions; own messages are not possible yet. Buttons show text, no icons.
- An emote is done at your current target (as in WoW); no target = a general emote.

## Development

Architecture, tests and engineering rules of the suite: [PaTiAdmin](https://github.com/patpaskoch/PaTiAdmin). PaTiAdmin is not a WoW addon — players do not install it. The shared UI code (PaTiShared) is already embedded in this addon's `Shared/` folder; there is nothing extra to install.

## License
MIT — see [LICENSE](LICENSE). Copyright (c) 2026 Patrick Koch.
