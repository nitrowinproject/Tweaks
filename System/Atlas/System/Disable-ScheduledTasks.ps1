Write-Host "Disabling privacy-compromising scheduled tasks..." -ForegroundColor DarkGray

$tasks = @(
    @("PcaPatchDbTask", "\Microsoft\Windows\Application Experience\"),
    @("UCPD velocity", "\Microsoft\Windows\AppxDeploymentClient\"),
    @("UsageDataReporting", "\Microsoft\Windows\Flighting\FeatureConfig\")
)

foreach ($task in $tasks) {
    $taskName = $task[0]
    $taskPath = $task[1]
    try {
        Write-Host "Disabling scheduled task: $taskName..."
        Get-ScheduledTask -TaskName $taskName -TaskPath $taskPath | Disable-ScheduledTask
        Write-Host "Disabled scheduled task successfully: $taskName!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to disable scheduled task: $taskName! Error: $_" -ForegroundColor Red
    }
}
try {
    Write-Host "Disabling usage data reporting..."
    Remove-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Ubpm" -Name "CriticalMaintenance_UsageDataReporting" -Force
    Write-Host "Usage data reporting has been disabled successfully!" -ForegroundColor Green
}
catch {
    Write-Host "Failed to remove registry key: $_" -ForegroundColor Red
}