# Build status — 2026-10-14

## Compiled development candidate

- Source: `src/SpiderSwingASI.cpp` and `src/native_api.hpp`
- Build command: `build-melty.cmd`
- Output: `build/SpiderSwingASI.asi`
- Compiler: Visual Studio 2022 C++ x64 Build Tools
- Result: MSVC build succeeded.
- PE audit: x64 DLL/ASI format; imports only `USER32.dll` and `KERNEL32.dll`; no ScriptHookV import.
- Controls: F7 toggles traversal; F8 shoots/releases a web; W/Up steers while attached.
- Features in source: camera raycast, visible web strand, basic tether force and forward steering.

**Evidence level:** compile success only. The plugin has not been launched in GTA V. It is not yet a verified playable build.

## Melty paired-launch draft

- The local recipe now declares GTA V Legacy as primary and `marvels-spider-man-remastered` as companion.
- The `together` launch uses `{game:marvels-spider-man-remastered}/Spider-Man.exe`, starts it first with `-scripts`, waits five seconds, then launches GTA V Legacy with the official `-nobattleye` Story Mode argument.
- Local validator checks that the companion game, game-path token, launch order, and Story Mode argument are present.
- This pairing has **not** been checked by Melty's actual validator or one-click test. The recipe/package is still a local draft and has not been uploaded.
- Important: starting both games is not yet content integration. The GTA character still uses the GTA model; Peter Parker, Remastered suits, animations, and sounds do not yet drive GTA movement.

## Required before claiming playable

1. Run Melty's actual recipe/package/one-click checks.
2. Launch through Melty in GTA V Legacy Story Mode only, with `-nobattleye`; never use GTA Online.
3. Test attachment/release, collision, death/respawn, vehicle entry, pause/focus loss, and clean shutdown.
4. Record genuine logs and gameplay evidence.
5. Research and prove a legal/technical path for local Remastered asset/animation use, without redistributing game or third-party mod assets.

## Distribution rules

- Do not include GTA/Spider-Man game files, executables, saves, or extracted proprietary assets.
- Preserve MIT, MinHook BSD-style, and GPL-2.0 native-mapping notices.
- Do not publish a public release until a working build, evidence, Melty validation, and explicit user approval exist.
