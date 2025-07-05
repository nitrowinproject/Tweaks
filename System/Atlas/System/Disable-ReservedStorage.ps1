Write-Host "Disabling Reserved Storage..." -ForegroundColor DarkGray

Start-Process -Wait -NoNewWindow -FilePath "dism.exe" -ArgumentList "/Online /Set-ReservedStorageState /State:Disabled"