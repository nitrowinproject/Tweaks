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
        Write-Debug "Starting Windows Time service..."
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