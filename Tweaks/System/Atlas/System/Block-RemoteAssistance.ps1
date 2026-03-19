Write-Host "Disabling Remote Assistance..." -ForegroundColor DarkGray

Start-Process -Wait -NoNewWindow -FilePath "netsh.exe" -ArgumentList 'advfirewall firewall set rule group="Remote Assistance" new enable=no'