Get-AppxPackage -AllUsers Microsoft.Copilot* | Remove-AppxPackage -AllUsers
Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
Set-Service -Name "DiagTrack" -StartupType Disabled
Remove-Item -Path "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\DiagTrack*" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\ShutdownLogger\DiagTrack*" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Force -ErrorAction SilentlyContinue
Start-Process -Wait -NoNewWindow -FilePath "netsh.exe" -ArgumentList 'advfirewall firewall set rule group="Remote Assistance" new enable=no'
Start-Process -Wait -NoNewWindow -FilePath "dism.exe" -ArgumentList "/Online /Set-ReservedStorageState /State:Disabled"
Get-ScheduledTask -TaskName "PcaPatchDbTask" -TaskPath "\Microsoft\Windows\Application Experience\" | Disable-ScheduledTask
Get-ScheduledTask -TaskName "UCPD velocity" -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" | Disable-ScheduledTask
Get-ScheduledTask -TaskName "UsageDataReporting" -TaskPath "\Microsoft\Windows\Flighting\FeatureConfig\" | Disable-ScheduledTask
Remove-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Ubpm" -Name "CriticalMaintenance_UsageDataReporting" -Force
Get-ScheduledTask -TaskName "AnalyzeSystem" -TaskPath "\Microsoft\Windows\Power Efficiency Diagnostics\" | Disable-ScheduledTask
Start-Process -Wait -NoNewWindow -FilePath "wevtutil" -ArgumentList 'set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false'
Start-Process -Wait -NoNewWindow -FilePath "wevtutil" -ArgumentList 'set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false'
Start-Process -Wait -NoNewWindow -FilePath "wevtutil" -ArgumentList 'set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false' 
Start-Process -Wait -NoNewWindow -FilePath "fsutil.exe" -ArgumentList "behavior set disablelastaccess 1" 
Start-Process -Wait -NoNewWindow -FilePath "fsutil.exe" -ArgumentList "behavior set disable8dot3 1"
[System.Environment]::SetEnvironmentVariable("DOTNET_CLI_TELEMETRY_OPTOUT", "1", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", "1", [System.EnvironmentVariableTarget]::Machine)
Start-Process -Wait -NoNewWindow -FilePath "powercfg.exe" -ArgumentList "/duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61"
Disable-WindowsOptionalFeature -FeatureName WorkFolders-Client -NoRestart -Online
Disable-WindowsOptionalFeature -FeatureName Printing-PrintToPDFServices-Features -NoRestart -Online
# The base idea of this tweak comes from Atlas, but I modified it to give me more local time servers.

$region = ((Get-WinSystemLocale).Name).Split("-")[1].ToLower()

$servers = "0.$region.pool.ntp.org 1.$region.pool.ntp.org 2.$region.pool.ntp.org 3.$region.pool.ntp.org"

Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/config /syncfromflags:manual /manualpeerlist:`"$servers`""
Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/config /update"
Start-Process -Wait -NoNewWindow -FilePath "w32tm" -ArgumentList "/resync"
