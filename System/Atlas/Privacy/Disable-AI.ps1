Write-Host "Removing Copilot..." -ForegroundColor DarkGray

try {
    Get-AppxPackage -AllUsers Microsoft.Copilot* | Remove-AppxPackage -AllUsers
    Write-Host "Copilot has been removed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Failed to remove Copilot: $_" -ForegroundColor Red
}