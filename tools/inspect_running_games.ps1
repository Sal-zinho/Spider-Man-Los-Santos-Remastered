$ErrorActionPreference = 'Continue'
$g = Get-Process -Name GTA5 -ErrorAction SilentlyContinue
$sp = Get-Process -Name Spider-Man -ErrorAction SilentlyContinue
if ($g) {
  Write-Output "GTA5_RUNNING PID=$($g[0].Id) CPU=$($g[0].CPU) WS_MB=$([math]::Round($g[0].WorkingSet64/1MB))"
  try {
    $mods = $g[0].Modules | Where-Object { $_.ModuleName -match 'SpiderSwingASI|dinput8|Ultimate|version.dll|ScriptHook' } | Select-Object ModuleName,FileName
    if ($mods) { $mods | Format-Table -AutoSize } else { Write-Output 'NO_TARGET_ASI_LOADER_MODULES_VISIBLE' }
  } catch { Write-Output "MODULE_ENUMERATION_BLOCKED: $($_.Exception.Message)" }
} else { Write-Output 'GTA5_NOT_RUNNING' }
if ($sp) { Write-Output "SPIDER_MAN_RUNNING PID=$($sp[0].Id) WS_MB=$([math]::Round($sp[0].WorkingSet64/1MB))" } else { Write-Output 'SPIDER_MAN_NOT_RUNNING' }
