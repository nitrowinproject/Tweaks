Write-Host "Adding Ultimate Power Plan..."

Start-Process -Wait -NoNewWindow -FilePath "powercfg.exe" -ArgumentList "/duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61"