Write-Host "Removing Copilot..." -ForegroundColor DarkGray

try {
    Get-AppxPackage -AllUsers Microsoft.Copilot* | Remove-AppxPackage -AllUsers
    Write-Host "Copilot has been removed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "Failed to remove Copilot: $_" -ForegroundColor Red
}
Write-Host "Disabling DiagTrack..." -ForegroundColor DarkGray

try {
    Write-Host "Stopping and disabling the DiagTrack service..."

    Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "DiagTrack" -StartupType Disabled

    Write-Host "DiagTrack has been disabled successfully!" -ForegroundColor Green
}
catch {
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
    }
    catch {
        Write-Host "Failed to remove logs from: $path`: $_" -ForegroundColor Red
    }
}
Write-Host "Disabling feedback..." -ForegroundColor DarkGray

try {
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Force
    Write-Host "Feedback has been disabled successfully!" -ForegroundColor Green
}
catch {
    Write-Host "Failed to disable feedback: $_" -ForegroundColor Red
}
Write-Host "Disabling Remote Assistance..." -ForegroundColor DarkGray

Start-Process -Wait -NoNewWindow -FilePath "netsh.exe" -ArgumentList 'advfirewall firewall set rule group="Remote Assistance" new enable=no'
Write-Host "Disabling Reserved Storage..." -ForegroundColor DarkGray

Start-Process -Wait -NoNewWindow -FilePath "dism.exe" -ArgumentList "/Online /Set-ReservedStorageState /State:Disabled"
Write-Host "Disabling privacy-compromising scheduled tasks..." -ForegroundColor DarkGray

$tasks = @(
    @("PcaPatchDbTask", "\Microsoft\Windows\Application Experience\")
    @("UCPD velocity", "\Microsoft\Windows\AppxDeploymentClient\")
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
Write-Host "Disabling sleep study..." -ForegroundColor DarkGray

try {
    Write-Host "Disabling sleep study scheduled tasks..."
    Get-ScheduledTask -TaskName "SleepStudy" -TaskPath "\Microsoft\Windows\Power Efficiency Diagnostics\" | Disable-ScheduledTask
    Write-Host "Disabled sleep study scheduled tasks successfully!" -ForegroundColor Green
}
catch {
    Write-Host "Failed to disable sleep study scheduled tasks: $_" -ForegroundColor Red
}

$wevArgs = @(
    "Microsoft-Windows-SleepStudy/Operational"
    "Microsoft-Windows-SleepStudy/Diagnostic"
    "Microsoft-Windows-Kernel-Processor-PowerDiagnostic"
    "Microsoft-Windows-UserModePowerService/Diagnostic"
)

foreach ($log in $wevArgs) {
    try {
        Write-Host "Disabling event log: $log..."
        Start-Process -Wait -NoNewWindow -FilePath "wevtutil" -ArgumentList "set-log `"$log`" /e:false"
        Write-Host "Disabled event log successfully: $log!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to disable event log: $log! Error: $_" -ForegroundColor Red
    }
}
Write-Host "Optimizing NTFS options..." -ForegroundColor DarkGray

Start-Process -Wait -NoNewWindow -FilePath "fsutil.exe" -ArgumentList "behavior set disablelastaccess 1"
Start-Process -Wait -NoNewWindow -FilePath "fsutil.exe" -ArgumentList "behavior set disable8dot3 1"
Write-Host "Disabling telemetry for various applications..." -ForegroundColor DarkGray

$variables = @(
    "DOTNET_CLI_TELEMETRY_OPTOUT"
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
    }
    else {
        Write-Host "$var is already set to 1" -ForegroundColor Yellow
    }
}
Write-Host "Adding Ultimate Power Plan..." -ForegroundColor DarkGray

$keywords = @("Enterprise", "Workstation")
$regex = [string]::Join("|", $keywords)

if (-Not (Get-WindowsEdition -Online).Edition -match $regex) {
    Start-Process -Wait -NoNewWindow -FilePath "powercfg.exe" -ArgumentList "/duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61"
    Write-Host "Added Ultimate Power Plan!" -ForegroundColor Green
}
else {
    Write-Host "Not adding Ultimate Power Plan because it's already installed..."
}
Write-Host "Disabling unused Windows features..." -ForegroundColor DarkGray

$features = @(
    "WorkFolders-Client"
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
Write-Host "Setting local time servers..." -ForegroundColor DarkGray

try {
    Write-Host "Detecting region..."
    $response = Invoke-RestMethod -Uri "https://ipinfo.io/json"
    $region = $response.country.ToLower()
    Write-Host "Detected region: $region!" -ForegroundColor Green
    $servers = "0.$region.pool.ntp.org 1.$region.pool.ntp.org 2.$region.pool.ntp.org 3.$region.pool.ntp.org"
}
catch {
    Write-Host "Failed to retrieve region information: $_" -ForegroundColor Red
    Write-Host "Using default time servers instead..." -ForegroundColor Yellow
    $servers = "0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
}

if ((Get-Service -Name "w32time").Status -ne 'Running') {
    try {
        Write-Host "Starting Windows Time service..."
        Start-Service -Name "w32time"
        Write-Host "Started Windows Time service!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to start Windows Time service: $_" -ForegroundColor Red
    }
}

Write-Host "Setting time servers to: $servers..."
Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/config /update /syncfromflags:manual /manualpeerlist:`"$servers`""

Write-Host "Resyncing time..."
Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/resync"
