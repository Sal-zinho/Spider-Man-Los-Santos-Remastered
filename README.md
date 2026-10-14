# Spider-Man: Los Santos — Remastered Edition

Independent fan project targeting GTA V Legacy Story Mode, paired with the user's own Marvel's Spider-Man Remastered installation.

## Current development candidate

- Host: GTA V Legacy build 1.0.3889.0
- Companion: Marvel's Spider-Man Remastered, configured to start first through Melty
- Controls in the GTA-side prototype: F7 toggles traversal; F8 attaches/releases a web; hold W or Up to steer
- Prototype mechanic: camera raycast anchor, visible web strand, basic tether force, momentum-preserving radial correction and forward steering

**Status: compile-only prototype plus a paired-launch draft.** The ASI compiles, but it has not been run in GTA. The Melty recipe now declares both games and uses the companion path token to start Spider-Man Remastered with `-scripts` before GTA V Legacy with the official `-nobattleye` Story Mode argument.

This is not yet the completed mashup: the GTA player model is unchanged, and Peter Parker's model, suits, animations, sounds, or Overstrike mods are not yet integrated into GTA. The two games' launch configuration has not been validated by Melty or tested in-game.

## Build and validation

Run `build-melty.cmd` with Visual Studio 2022 C++ x64 Build Tools. Local checks currently include recipe/package validation, `um publish check`, and four traversal-physics unit tests. These checks do not substitute for Melty's own validation or a real gameplay test.

## Safety and distribution

- GTA V Story Mode only. Never use this mod in GTA Online.
- No game executables, archives, saves, or extracted proprietary assets are included.
- Preserve separate MIT, MinHook BSD-style, and GPL-2.0 native-mapping notices.
- No Melty upload/public release has occurred. Publication requires actual Melty validation, real gameplay evidence, and your explicit approval.
- Unofficial fan project, not affiliated with Rockstar Games, Marvel, Sony, Insomniac Games, Nixxes, or Melty.

See `docs/BUILD_STATUS.md`, `docs/REFERENCE_ADAPTATION.md`, and `docs/MELTY_RELEASE_POLICY.md` for blockers and release gates.
