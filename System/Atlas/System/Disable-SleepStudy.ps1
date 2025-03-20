Get-ScheduledTask -TaskName "AnalyzeSystem" -TaskPath "\Microsoft\Windows\Power Efficiency Diagnostics\" | Disable-ScheduledTask
Start-Process -Wait -NoNewWindow -FilePath "wevtutil" -ArgumentList 'set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false'
Start-Process -Wait -NoNewWindow -FilePath "wevtutil" -ArgumentList 'set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false'
Start-Process -Wait -NoNewWindow -FilePath "wevtutil" -ArgumentList 'set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false' 