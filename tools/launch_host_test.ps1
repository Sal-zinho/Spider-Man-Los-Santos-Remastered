$ErrorActionPreference = 'Stop'
$steam = 'C:\Program Files (x86)\Steam\steam.exe'
$sp = Get-Process -Name 'Spider-Man' -ErrorAction SilentlyContinue
if (-not $sp) { throw 'Spider-Man Remastered is not running; stopping test before launching GTA.' }
if (Get-Process -Name 'GTA5' -ErrorAction SilentlyContinue) { Write-Output 'GTA_ALREADY_RUNNING' } else {
  Start-Process -FilePath $steam -ArgumentList @('-applaunch','271590','-nobattleye')
  Write-Output 'GTA_LAUNCH_REQUESTED_VIA_STEAM_WITH_STORY_MODE_ARG'
}
Start-Sleep -Seconds 20
Get-Process | Where-Object { $_.ProcessName -match 'Spider|GTA5|PlayGTAV|Launcher' } | Select-Object ProcessName,Id,CPU,WorkingSet64 | Format-Table -AutoSize
