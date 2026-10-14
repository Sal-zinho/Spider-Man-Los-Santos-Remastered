# Melty release policy — Spider-Man: Los Santos Remastered Edition

## User requirement
Every genuinely playable build should be kept in the Melty release flow. Do not label source-only, compile-only, or untested artifacts as playable.

## Release gates
1. **Source prototype** — code exists, not a playable build.
2. **Compiled candidate** — ASI compiles, but has not been verified in-game.
3. **Paired-launch draft** — recipe declares GTA V Legacy and Marvel's Spider-Man Remastered and configures the companion to launch first. This is not proof of data/gameplay integration.
4. **Gameplay-tested candidate** — launched through Melty in GTA V Legacy Story Mode and passes the smoke tests in docs/BUILD_STATUS.md.
5. **Melty playable build** — actual Melty recipe/package/one-click checks pass, requirements are disclosed, and the companion integration claims are accurate.
6. **Public release** — only after the user explicitly approves publication.

## Package constraints
- Host: GTA V Legacy (gta-v), Story Mode only, supported build 1.0.3889.0.
- Companion: Marvel's Spider-Man Remastered (marvels-spider-man-remastered), launched first through the together recipe entry with -scripts.
- GTA V launch uses the official -nobattleye Story Mode argument. Never use GTA Online and never modify/bypass BattlEye.
- The current code still applies traversal to GTA's existing player model. It does not yet use Remastered Peter Parker models, suits, animations, sounds, or Overstrike mods.
- Do not redistribute proprietary game assets or third-party Spider-Man mod content without confirmed permission.
- Keep version, build number, test evidence, requirements, notices, and limitations with each candidate.
- If Melty's companion launch or one-click support cannot be verified, disclose that limitation.

## Current status — 2026-10-14
The native-adapter ASI compiles but has not been run in-game. The paired-launch recipe passes local checks, but Melty's own validation/one-click checks have not run. No upload or public release has occurred. This is a paired-launch development draft, not a verified playable mashup.
