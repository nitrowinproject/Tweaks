Write-Host "Disabling telemetry for various applications..."

$variables = @(
    "DOTNET_CLI_TELEMETRY_OPTOUT",
    "POWERSHELL_TELEMETRY_OPTOUT"
)

foreach ($var in $variables) {
    if ([System.Environment]::GetEnvironmentVariable($var, [System.EnvironmentVariableTarget]::Machine) -ne "1") {
        try {
            Write-Host "Setting $var to 1"
            [System.Environment]::SetEnvironmentVariable($var, "1", [System.EnvironmentVariableTarget]::Machine)
            Write-Host "$var has been set to 1" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to set $var`: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "$var is already set to 1" -ForegroundColor Yellow
    }
}