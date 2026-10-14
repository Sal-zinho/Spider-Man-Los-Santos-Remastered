$ErrorActionPreference = 'Stop'
$steam = 'C:\Program Files (x86)\Steam\steam.exe'
Start-Process -FilePath $steam -ArgumentList @('-applaunch','1817070')
Start-Sleep -Seconds 20
$found = Get-Process | Where-Object { $_.ProcessName -match 'Spider|Marvel|steam' } | Select-Object ProcessName,Id,CPU,WorkingSet64
$found | Format-Table -AutoSize
if (-not ($found | Where-Object { $_.ProcessName -match 'Spider|Marvel' })) { Write-Output 'GAME_PROCESS_NOT_PRESENT' }
