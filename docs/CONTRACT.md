# Bridge contract — paired-launch draft

- Host process: GTA V Legacy Story Mode. Host owns world coordinates, camera, collision, player lifecycle, and return-to-GTA control.
- Companion process: the user's installed Marvel's Spider-Man Remastered, configured to start first via Melty's together entry and the path token {game:marvels-spider-man-remastered}. It is launched with -scripts.
- Current verified data crossing: none. The current pair launches are configuration only; there is no live IPC, animation transfer, mesh transfer, or gameplay-state bridge yet.
- Intended future crossing: versioned local JSON/named-pipe messages for allowed movement/suit metadata, after the companion-side data source and its format are proved. Bind IPC to local machine only.
- Coordinate conversion: not yet defined. Must be derived from measured host/guest reference points, not guessed.
- Input ownership: GTA controls by default. Traversal mode may capture only documented movement inputs and must release them on disable, death, pause, focus loss, or bridge failure.
- Lifecycle: fail closed if host build mismatch or host leaves Story Mode. Never connect to GTA Online.
- Evidence: keep logs and test artifacts outside either game's install folder.
- Distribution: do not ship game executables, archives, extracted proprietary assets, saves, or third-party mod assets without permission.
