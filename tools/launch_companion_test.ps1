$ErrorActionPreference = 'Stop'
$spider = "C:\Program Files (x86)\Steam\steamapps\common\Marvel's Spider-Man Remastered\Spider-Man.exe"
$gta = 'C:\Program Files (x86)\Steam\steamapps\common\Grand Theft Auto V\GTA5.exe'
if (-not (Test-Path -LiteralPath $spider)) { throw "Spider-Man Remastered executable not found: $spider" }
if (-not (Test-Path -LiteralPath $gta)) { throw "GTA V executable not found: $gta" }
if (-not (Get-Process -Name 'Spider-Man' -ErrorAction SilentlyContinue)) {
  $p = Start-Process -FilePath $spider -ArgumentList '-scripts' -PassThru
  Write-Output "SPIDER_MAN_STARTED PID=$($p.Id)"
} else { Write-Output 'SPIDER_MAN_ALREADY_RUNNING' }
Start-Sleep -Seconds 8
$sp = Get-Process -Name 'Spider-Man' -ErrorAction SilentlyContinue
if ($sp) { Write-Output "SPIDER_MAN_PROCESS_PRESENT PID=$($sp[0].Id)" } else { Write-Output 'SPIDER_MAN_PROCESS_NOT_FOUND_AFTER_LAUNCH' }
