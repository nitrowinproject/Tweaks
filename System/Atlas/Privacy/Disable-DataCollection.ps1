Write-Host "Disabling DiagTrack..." -ForegroundColor DarkGray

try {
    Write-Host "Stopping and disabling the DiagTrack service..."

    Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "DiagTrack" -StartupType Disabled

    Write-Host "DiagTrack has been disabled successfully!" -ForegroundColor Green
} catch {
    Write-Host "Failed to disable DiagTrack service: $_" -ForegroundColor Red
}

$paths = @(
    "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\DiagTrack*",
    "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\ShutdownLogger\DiagTrack*"
)

Write-Host "Removing DiagTrack logs..."

foreach ($path in $paths) {
    try {
        Write-Host "Removing logs from: $path..."
        Remove-Item -Path $path -Force
        Write-Host "Removed logs from: $path!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to remove logs from: $path`: $_" -ForegroundColor Red
    }
}
