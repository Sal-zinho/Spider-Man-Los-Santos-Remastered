$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$recipePath = Join-Path $root 'melty.json'
$recipe = Get-Content -LiteralPath $recipePath -Raw | ConvertFrom-Json
if ($recipe.schemaVersion -ne 1) { throw 'Unexpected Melty schemaVersion.' }
if ($recipe.games[0].slug -ne 'gta-v' -or $recipe.games[0].version -ne '=1.0.3889.0') { throw 'Host game/version pin mismatch.' }
if (-not ($recipe.games | Where-Object { $_.slug -eq 'marvels-spider-man-remastered' -and $_.role -eq 'companion' })) { throw 'Spider-Man Remastered companion game is missing.' }
if (-not ($recipe.together | Where-Object { $_.launch.path -eq '{game:marvels-spider-man-remastered}/Spider-Man.exe' -and $_.launch.args -contains '-scripts' -and $_.startFirst -eq $true })) { throw 'Companion launch path/token or start order is missing.' }
if ($recipe.launch.kind -ne 'game' -or $recipe.launch.args -notcontains '-nobattleye') { throw 'Official Story Mode launch argument is missing.' }
if (-not ($recipe.requirements | Where-Object { $_.kind -eq 'loader' -and $_.id -eq 'ultimate-asi-loader' })) { throw 'Ultimate ASI Loader requirement is missing.' }
$zipPath = Join-Path (Join-Path $root 'release') $recipe.components[0].fileName
if (-not (Test-Path -LiteralPath $zipPath)) { throw 'Recipe component ZIP is missing.' }
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
try {
  $names = @($zip.Entries | ForEach-Object { $_.FullName.Replace([char]92,[char]47) })
  foreach ($required in @('gta/SpiderSwingASI.asi','gta/SpiderSwing/native-map.csv','docs/README.md','docs/THIRD_PARTY_NOTICES.md','source/SpiderSwingASI.cpp','source/native_runtime.cpp')) {
    if ($required -notin $names) { throw "Missing package entry: $required" }
  }
  $bad = @($names | Where-Object { $_ -match '(^|/)(GTA5\.exe|Spider-Man\.exe|ScriptHookV\.dll|dinput8\.dll|update\.rpf|.*\.sav)$' })
  if ($bad.Count) { throw ('Game/loader file accidentally packaged: ' + ($bad -join ', ')) }
  $mapEntry = $zip.Entries | Where-Object { $_.FullName -like '*native-map.csv' } | Select-Object -First 1
  if (-not $mapEntry) { throw 'Native map is missing from the archive.' }
  $reader = [System.IO.StreamReader]::new($mapEntry.Open())
  try { $mapLines = @($reader.ReadToEnd() -split '\r?\n' | Where-Object { $_.Trim() }) } finally { $reader.Dispose() }
  if ($mapLines.Count -ne 14) { throw "Expected 14 native map entries, got $($mapLines.Count)." }
  Write-Output 'PASS: recipe JSON and host version pin'
  Write-Output 'PASS: Spider-Man Remastered companion is declared and launched first via its game-path token'
  Write-Output 'PASS: official Story Mode launch argument and loader requirement'
  Write-Output ('PASS: package entries (' + $names.Count + ')')
  Write-Output 'PASS: no game executables, game archives, or loader DLLs included'
  Write-Output ('PASS: native map is minimal (' + $mapLines.Count + ' entries)')
  Write-Output ('Archive: ' + $zipPath)
  Write-Output ('Bytes: ' + (Get-Item $zipPath).Length)
} finally {
  $zip.Dispose()
}