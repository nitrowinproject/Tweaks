net stop DiagTrack > nul 2>&1
del "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\DiagTrack*" "%ProgramData%\Microsoft\Diagnosis\ETLLogs\ShutdownLogger\DiagTrack*" > nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f
netsh.exe advfirewall firewall set rule group="Remote Assistance" new enable=no
dism.exe /Online /Set-ReservedStorageState /State:Disabled
SCHTASKS /Change /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\AppxDeploymentClient\UCPD velocity" /DISABLE 2>nul
SCHTASKS /Change /TN "\Microsoft\Windows\Flighting\FeatureConfig\UsageDataReporting" /DISABLE 2>nul
REG DELETE "HKLM\System\CurrentControlSet\Control\Ubpm" /V "CriticalMaintenance_UsageDataReporting" /F
wevtutil.exe set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false
wevtutil.exe set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false
wevtutil.exe set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false
schtasks /Change /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable
fsutil.exe behavior set disablelastaccess 1
fsutil.exe behavior set disable8dot3 1
powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
