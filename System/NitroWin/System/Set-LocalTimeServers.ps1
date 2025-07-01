$response = Invoke-RestMethod -Uri "https://ipinfo.io/json"
$region = $response.country.ToLower()

$servers = "0.$region.pool.ntp.org 1.$region.pool.ntp.org 2.$region.pool.ntp.org 3.$region.pool.ntp.org"

Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/config /syncfromflags:manual /manualpeerlist:`"$servers`""
Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/config /update"
Start-Process -Wait -NoNewWindow -FilePath "w32tm" -ArgumentList "/resync"