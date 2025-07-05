Write-Host "Disabling sleep study..." -ForegroundColor DarkGray

try {
    Write-Host "Disabling sleep study scheduled tasks..."
    Get-ScheduledTask -TaskName "SleepStudy" -TaskPath "\Microsoft\Windows\Power Efficiency Diagnostics\" | Disable-ScheduledTask
    Write-Host "Disabled sleep study scheduled tasks successfully!" -ForegroundColor Green
} catch {
    Write-Host "Failed to disable sleep study scheduled tasks: $_" -ForegroundColor Red
}

$wevArgs = @(
    "Microsoft-Windows-SleepStudy/Operational",
    "Microsoft-Windows-SleepStudy/Diagnostic",
    "Microsoft-Windows-Kernel-Processor-Power/Diagnostic",
    "Microsoft-Windows-UserModePowerService/Diagnostic"
)

foreach ($log in $wevArgs) {
    try {
        Write-Host "Disabling event log: $log..."
        Start-Process -Wait -NoNewWindow -FilePath "wevtutil" -ArgumentList "set-log `"$log`" /e:false"
        Write-Host "Disabled event log successfully: $log!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to disable event log: $log! Error: $_" -ForegroundColor Red
    }
}