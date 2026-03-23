try {
  $response = Invoke-RestMethod -Uri "https://ipinfo.io/json"
  $region = $response.country.ToLower()
  $servers = "0.$region.pool.ntp.org 1.$region.pool.ntp.org 2.$region.pool.ntp.org 3.$region.pool.ntp.org"
}
catch {
  $servers = "0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
}

if ((Get-Service -Name "w32time").Status -ne 'Running') {
  Start-Service -Name "w32time" -ErrorAction SilentlyContinue
}

Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/config /update /syncfromflags:manual /manualpeerlist:`"$servers`""
Start-Process -Wait -NoNewWindow -FilePath "w32tm.exe" -ArgumentList "/resync"
