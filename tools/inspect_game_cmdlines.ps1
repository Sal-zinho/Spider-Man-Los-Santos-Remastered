Get-CimInstance Win32_Process | Where-Object { $_.Name -match 'Melty|GTA5|Spider-Man|Launcher.exe' } | Select-Object Name,ProcessId,ExecutablePath,CommandLine | Format-List
