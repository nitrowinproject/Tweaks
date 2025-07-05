$response = Invoke-RestMethod -Uri "https://ipinfo.io/json"
$region = $response.country.ToLower()

if ((Get-Service -Name "w32time").Status -ne 'Running') {
    Start-Service -Name "w32time"
}

$servers = "0.$region.pool.ntp.org 1.$region.pool.ntp.org 2.$region.pool.ntp.org 3.$region.pool.ntp.org"
Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/config /update /syncfromflags:manual /manualpeerlist:`"$servers`""
Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/resync"