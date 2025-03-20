Get-ScheduledTask -TaskName "PcaPatchDbTask" -TaskPath "\Microsoft\Windows\Application Experience\" | Disable-ScheduledTask
Get-ScheduledTask -TaskName "UCPD velocity" -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" | Disable-ScheduledTask
Get-ScheduledTask -TaskName "UsageDataReporting" -TaskPath "\Microsoft\Windows\Flighting\FeatureConfig\" | Disable-ScheduledTask
Remove-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Ubpm" -Name "CriticalMaintenance_UsageDataReporting" -Force