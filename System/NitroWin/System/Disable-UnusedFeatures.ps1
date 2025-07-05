Write-Host "Disabling unused Windows features..."

$features = @(
    "WorkFolders-Client",
    "Printing-PrintToPDFServices-Features"
)

foreach ($feature in $features) {
    try {
        Write-Host "Disabling feature: $feature..."
        Disable-WindowsOptionalFeature -FeatureName $feature -NoRestart -Online
        Write-Host "Feature '$feature' disabled successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to disable feature '$feature': $_" -ForegroundColor Red
    }
}