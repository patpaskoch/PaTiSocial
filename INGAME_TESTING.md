# Ingame Testing – PaTiSocial

World of Warcraft: Forever
Interface: 16001

Diese Datei dokumentiert ausschließlich Tests im echten WoW-Client.

Automatisierte Tests, CI und Code Review zählen NICHT als Ingame-Verifikation.
Regeln und Eintragen von Ergebnissen: [PaTiAdmin/docs/TESTING.md](https://github.com/patpaskoch/PaTiAdmin/blob/main/docs/TESTING.md#in-game-test-files).

## Legende

- [ ] offen / noch nicht bestätigt
- [x] vom Owner im echten Client bestätigt
- ❌ FAIL = im echten Client fehlgeschlagen
- 🔧 FIX IMPLEMENTED = Codefix vorhanden, Retest noch offen
- ✅ VERIFIED = erfolgreich im echten Client bestätigt
- MANUAL RETEST REQUIRED = erneuter Test notwendig

## Installation / Laden

- [ ] PT-SOCIAL-001 Fresh Install aus dem Release-ZIP: genau ein Ordner `PaTiSocial/`, Addon lädt allein
- [ ] PT-SOCIAL-002 PaTiSocial erscheint in der AddOn-Liste mit Beschreibung
- [ ] PT-SOCIAL-003 Login ohne Lua-Fehler
- [ ] PT-SOCIAL-004 `/reload` ohne Lua-Fehler
- [ ] PT-SOCIAL-005 `/psocial debug`: DoEmote und SendChatMessage vorhanden, Anzahl gefundener Emote-Tokens, Liste der
  angebotenen und nicht angebotenen Aktionen (Ausgabe melden)
- [x] PT-SOCIAL-006 Icon in der AddOn-Liste korrekt (Sprechblase mit zwei Figuren), keine weiße oder fehlende Textur
  - ✅ VERIFIED 2026-10-02
  - Owner: die Icons erscheinen im Spiel in der AddOn-Liste korrekt.

## Fenster

- [ ] PT-SOCIAL-010 Fenstertitel „Party Social“; `/psocial` und `/patisocial` blenden es ein/aus; `/psocial show`, `hide`
- [ ] PT-SOCIAL-011 Am Header verschieben; Position bleibt nach `/reload`
- [ ] PT-SOCIAL-012 Lock/Unlock (••• und `/psocial lock` / `unlock`): gesperrt nicht verschiebbar
- [ ] PT-SOCIAL-013 Größe (Scale) wirkt
- [ ] PT-SOCIAL-014 Panel-Deckkraft 30–100 %: nur der Hintergrund ändert sich
- [ ] PT-SOCIAL-015 ••• → Einklappen: nur der Header bleibt; Ausklappen: Buttons wieder da; bleibt nach `/reload`
- [ ] PT-SOCIAL-016 `/psocial reset` setzt die Position zurück

## Buttons und Layout

- [ ] PT-SOCIAL-020 Erster Start: sechs Buttons Winken, Danke, Lachen, Los!, Warten, Jubeln
- [ ] PT-SOCIAL-021 Anzahl 4 / 6 / 8 in den Einstellungen: sofort sichtbar, leere Plätze erscheinen nicht
- [ ] PT-SOCIAL-022 Layout Horizontal: Buttons nebeneinander, nichts abgeschnitten oder überlappt
- [ ] PT-SOCIAL-023 Layout Vertikal: ein Button pro Zeile, gleich breit, nichts abgeschnitten
- [ ] PT-SOCIAL-024 Anzahl und Layout bleiben nach `/reload`
- [ ] PT-SOCIAL-025 Hover hellt den Button auf; Tooltip steht neben dem Button, nicht darüber

## Emotes

- [ ] PT-SOCIAL-030 Winken: ein Klick = genau ein Emote (Chat zeigt es einmal), kein Lua-Fehler
- [ ] PT-SOCIAL-031 Danke, Lachen, Jubeln: je ein Klick = ein Emote
- [ ] PT-SOCIAL-032 Mit Ziel: das Emote geht an das Ziel; ohne Ziel: allgemeines Emote
- [ ] PT-SOCIAL-033 Ein Emote, das der Client nicht kennt, wird nicht angeboten (`/psocial debug`)

## Chat

- [ ] PT-SOCIAL-040 „Hallo!“ (Sagen): ein Klick = genau eine Nachricht im Sagen-Kanal, kein Fehler
  `ADDON_ACTION_BLOCKED`
- [ ] PT-SOCIAL-041 Gruppen-Nachricht (z. B. „Los!“) in einer Gruppe: genau eine Nachricht im Gruppenchat
- [ ] PT-SOCIAL-042 Gruppen-Nachricht solo: Button ausgegraut, Tooltip „Nur in einer Gruppe.“, nichts wird gesendet
- [ ] PT-SOCIAL-043 Gruppe beitreten / verlassen: Gruppen-Buttons werden aktiv / grau, ohne `/reload`
- [ ] PT-SOCIAL-044 Schlachtzug-Nachricht nur im Schlachtzug; sonst ausgegraut (falls ein Schlachtzug verfügbar ist)

## Einstellungen

- [ ] PT-SOCIAL-050 Button 1 auf eine andere Aktion stellen: sofort sichtbar
- [ ] PT-SOCIAL-051 Button 1 wieder ändern; „Keine“ wählen → Button verschwindet
- [ ] PT-SOCIAL-052 Belegung bleibt nach `/reload` und Relog
- [ ] PT-SOCIAL-053 „Standard wiederherstellen“: sechs Standard-Buttons, Position bleibt
- [ ] PT-SOCIAL-054 deDE: alle Texte deutsch; enUS nach Sprachwahl; keine abgeschnittenen Texte

## PaTiSuite

- [ ] PT-SOCIAL-060 „Social“ erscheint in PaTiSuite (zwischen Dungeon und Alerts)
- [ ] PT-SOCIAL-061 Ein-/Ausblenden über PaTiSuite; Zustand bleibt nach `/reload` (PaTiSuite-Sichtbarkeit)

## Combat / Combined

- [ ] PT-SOCIAL-070 Im Kampf: Emote und Nachricht funktionieren, kein Lua-Fehler, kein `ADDON_ACTION_BLOCKED`
- [ ] PT-SOCIAL-071 Zusammen mit allen PaTi-Addons: kein Lua-Fehler, `/psocial` antwortet nur PaTiSocial
