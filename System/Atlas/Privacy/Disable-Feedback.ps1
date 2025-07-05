Write-Host "Disabling feedback..." -ForegroundColor DarkGray

try {
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Force
    Write-Host "Feedback has been disabled successfully!" -ForegroundColor Green
} catch {
    Write-Host "Failed to disable feedback: $_" -ForegroundColor Red
}