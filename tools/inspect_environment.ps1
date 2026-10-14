param(
  [string]$GtaPath = (Join-Path ${env:ProgramFiles(x86)} 'Steam\steamapps\common\Grand Theft Auto V'),
  [string]$SpiderManPath = (Join-Path ${env:ProgramFiles(x86)} "Steam\steamapps\common\Marvel's Spider-Man Remastered"),
  [string]$OverstrikePath = '',
  [string]$ReportPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'reports\environment.json')
)
$ErrorActionPreference = 'Continue'
$gta = $GtaPath
$sm = $SpiderManPath
$os = $OverstrikePath
$report = [ordered]@{
  generated_utc = [DateTime]::UtcNow.ToString('o')
  gta_path = $gta
  gta_exe_exists = Test-Path (Join-Path $gta 'GTA5.exe')
  gta_loaders = @('dinput8.dll','ScriptHookV.dll','OpenIV.asi','ScriptHookVDotNet.asi','args.txt') | ForEach-Object { [ordered]@{name=$_;exists=(Test-Path (Join-Path $gta $_))} }
  gta_mods_folder_exists = Test-Path (Join-Path $gta 'mods')
  gta_exe_version = (Get-Item (Join-Path $gta 'GTA5.exe') -ErrorAction SilentlyContinue).VersionInfo.FileVersion
  spiderman_path = $sm
  spiderman_exe_exists = Test-Path (Join-Path $sm 'Spider-Man.exe')
  spiderman_scripts_folder_exists = Test-Path (Join-Path $sm 'scripts')
  spiderman_scripts_folder_files = @(Get-ChildItem (Join-Path $sm 'scripts') -File -ErrorAction SilentlyContinue | ForEach-Object {$_.Name})
  overstrike_path = if ($os) { $os } else { $null }
  overstrike_exists = if ($os) { Test-Path (Join-Path $os 'Overstrike.exe') } else { $false }
  overstrike_profile_files = if ($os) { @(Get-ChildItem (Join-Path $os 'Profiles') -File -ErrorAction SilentlyContinue | ForEach-Object {$_.Name}) } else { @() }
  overstrike_mod_library_files = if ($os) { @(Get-ChildItem (Join-Path $os 'Mods Library') -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.Extension -in '.script','.stage','.suit','.modular'} | ForEach-Object {$_.Name}) } else { @() }
  notes = @('Read-only inspection; no game files modified.','Paths can be overridden with -GtaPath, -SpiderManPath, and -OverstrikePath.','This report does not establish game build compatibility or whether any mod works in-game.')
}
$parent = Split-Path -Parent $ReportPath
if ($parent -and !(Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
$report | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 $ReportPath
$report | ConvertTo-Json -Depth 6
