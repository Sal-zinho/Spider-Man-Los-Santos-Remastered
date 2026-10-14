# Reference adaptation plan: Spider-Man: Los Santos → Remastered Edition

## Goal
Use GTA V Legacy as the host and the user's installed Marvel's Spider-Man Remastered as the companion. The target experience is solo exploration of Los Santos with web traversal, with Peter Parker/Remastered content as the intended character source. Keep all playable candidates in the Melty release flow, but never label an untested draft as playable.

## Compatibility boundary
The Melty reference targets Spider-Man 2. Spider-Man 2's animation/audio/movement data is not automatically compatible with Remastered. Overstrike `.script` files are not GTA ASI plugins. The two games do not share a runtime merely because both are installed.

## Implemented now
- GTA-side traversal ASI compiles for GTA V Legacy 1.0.3889.0; F7 toggles the prototype, F8 attaches/releases a web, and W/Up steers.
- The Melty recipe declares both games and uses `together` to launch the user's installed Remastered executable first via `{game:marvels-spider-man-remastered}/Spider-Man.exe` with `-scripts`, then launches GTA V Legacy with `-nobattleye`.
- Local recipe/archive lint is being updated to enforce the companion launch contract.

## Not implemented or verified
- No Remastered model, suit, animation, sound, or Overstrike script currently drives GTA.
- The paired launch has not been validated by Melty.
- The ASI has not been run in GTA; no gameplay evidence exists.
- No public release or Melty upload has occurred.

## Next gates
1. Run local recipe/package validation and rebuild the draft archive.
2. Run Melty's actual one-click checks when the supported Melty workflow is available.
3. Only with user permission, test the pair in GTA Story Mode and capture genuine evidence.
4. Investigate a local-only converter/bridge for Remastered assets and animation data. Never redistribute extracted game assets or third-party mod assets without permission.
