$keywords = @("Enterprise", "Workstation")
$regex = [string]::Join("|", $keywords)

if (-Not (Get-WindowsEdition -Online).Edition -match $regex) {
    Write-Host "Adding Ultimate Power Plan..." -ForegroundColor DarkGray
    Start-Process -Wait -NoNewWindow -FilePath "powercfg.exe" -ArgumentList "/duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61"
}