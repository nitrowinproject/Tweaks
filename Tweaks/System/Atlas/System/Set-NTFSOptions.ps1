Write-Host "Optimizing NTFS options..." -ForegroundColor DarkGray

Start-Process -Wait -NoNewWindow -FilePath "fsutil.exe" -ArgumentList "behavior set disablelastaccess 1"
Start-Process -Wait -NoNewWindow -FilePath "fsutil.exe" -ArgumentList "behavior set disable8dot3 1"