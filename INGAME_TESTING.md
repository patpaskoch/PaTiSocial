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

- [x] PT-SOCIAL-001 Fresh Install aus dem Release-ZIP: genau ein Ordner `PaTiSocial/`, Addon lädt allein
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-002 PaTiSocial erscheint in der AddOn-Liste mit Beschreibung
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-003 Login ohne Lua-Fehler
  - ✅ VERIFIED 2026-10-02
  - Owner: PaTiSocial lädt ohne Fehler.
- [x] PT-SOCIAL-004 `/reload` ohne Lua-Fehler
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-005 `/psocial debug`: DoEmote und SendChatMessage vorhanden, Anzahl gefundener Emote-Tokens, Liste der
  angebotenen und nicht angebotenen Aktionen (Ausgabe melden)
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-006 Icon in der AddOn-Liste korrekt (Sprechblase mit zwei Figuren), keine weiße oder fehlende Textur
  - ✅ VERIFIED 2026-10-02
  - Owner: die Icons erscheinen im Spiel in der AddOn-Liste korrekt.

## Fenster

- [x] PT-SOCIAL-010 Fenstertitel „Party Social“; `/psocial` und `/patisocial` blenden es ein/aus; `/psocial show`, `hide`
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-011 Am Header verschieben; Position bleibt nach `/reload`
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-012 Lock/Unlock (••• und `/psocial lock` / `unlock`): gesperrt nicht verschiebbar
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-013 Größe (Scale) wirkt
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-014 Panel-Deckkraft 30–100 %: nur der Hintergrund ändert sich
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-015 ••• → Einklappen: nur der Header bleibt; Ausklappen: Buttons wieder da; bleibt nach `/reload`
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-016 `/psocial reset` setzt die Position zurück
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.

## Buttons und Layout

- [x] PT-SOCIAL-020 Erster Start: sechs Buttons Winken, Danke, Lachen, Los!, Warten, Jubeln
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-021 Anzahl 4 / 6 / 8 in den Einstellungen: sofort sichtbar, leere Plätze erscheinen nicht
  - ✅ VERIFIED 2026-10-02
  - Owner: die Anzahl der Buttons lässt sich ändern.
- [x] PT-SOCIAL-022 Layout Horizontal: Buttons nebeneinander, nichts abgeschnitten oder überlappt
  - ✅ VERIFIED 2026-10-02
  - Owner: horizontal funktioniert.
- [x] PT-SOCIAL-023 Layout Vertikal: ein Button pro Zeile, gleich breit, nichts abgeschnitten
  - ✅ VERIFIED 2026-10-02
  - Owner: vertikal funktioniert.
- [x] PT-SOCIAL-024 Anzahl und Layout bleiben nach `/reload`
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-025 Hover hellt den Button auf; Tooltip steht neben dem Button, nicht darüber
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.

## Emotes

- [x] PT-SOCIAL-030 Winken: ein Klick = genau ein Emote (Chat zeigt es einmal), kein Lua-Fehler
  - ✅ VERIFIED 2026-10-02
  - Owner: der Emote-Button funktioniert.
- [x] PT-SOCIAL-031 Danke, Lachen, Jubeln: je ein Klick = ein Emote
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-032 Mit Ziel: das Emote geht an das Ziel; ohne Ziel: allgemeines Emote
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-033 Ein Emote, das der Client nicht kennt, wird nicht angeboten (`/psocial debug`)
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.

## Chat

- [x] PT-SOCIAL-040 „Hallo!“ (Sagen): ein Klick = genau eine Nachricht im Sagen-Kanal, kein Fehler
  `ADDON_ACTION_BLOCKED`
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [ ] PT-SOCIAL-041 Gruppen-Nachricht (z. B. „Los!“) in einer Gruppe: genau eine Nachricht im Gruppenchat
- [x] PT-SOCIAL-042 Gruppen-Nachricht solo: Button ausgegraut, Tooltip „Nur in einer Gruppe.“, nichts wird gesendet
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [ ] PT-SOCIAL-043 Gruppe beitreten / verlassen: Gruppen-Buttons werden aktiv / grau, ohne `/reload`
- [ ] PT-SOCIAL-044 Schlachtzug-Nachricht nur im Schlachtzug; sonst ausgegraut (falls ein Schlachtzug verfügbar ist)

## Einstellungen

- [x] PT-SOCIAL-050 Button 1 auf eine andere Aktion stellen: sofort sichtbar
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-051 Button 1 wieder ändern; „Keine“ wählen → Button verschwindet
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-052 Belegung bleibt nach `/reload` und Relog
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-053 „Standard wiederherstellen“: sechs Standard-Buttons, Position bleibt
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-054 deDE: alle Texte deutsch; enUS nach Sprachwahl; keine abgeschnittenen Texte
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.

## PaTiSuite

- [x] PT-SOCIAL-060 „Social“ erscheint in PaTiSuite (zwischen Dungeon und Alerts)
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-061 Ein-/Ausblenden über PaTiSuite; Zustand bleibt nach `/reload` (PaTiSuite-Sichtbarkeit)
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.

## Combat / Combined

- [x] PT-SOCIAL-070 Im Kampf: Emote und Nachricht funktionieren, kein Lua-Fehler, kein `ADDON_ACTION_BLOCKED`
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
- [x] PT-SOCIAL-071 Zusammen mit allen PaTi-Addons: kein Lua-Fehler, `/psocial` antwortet nur PaTiSocial
  - ✅ VERIFIED 2026-11-08
  - Owner: auf der Testseite mit „Geht“ bestätigt.
