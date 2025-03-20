Get-AppxPackage -AllUsers Microsoft.Copilot* | Remove-AppxPackage -AllUsers
[System.Environment]::SetEnvironmentVariable("DOTNET_CLI_TELEMETRY_OPTOUT", "1", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", "1", [System.EnvironmentVariableTarget]::Machine)
# The base idea of this tweak comes from Atlas, but I modified it to give me more local time servers.

$region = ((Get-WinSystemLocale).Name).Split("-")[1].ToLower()

$servers = "0.$region.pool.ntp.org 1.$region.pool.ntp.org 2.$region.pool.ntp.org 3.$region.pool.ntp.org"

Start-Process -wait -FilePath "w32tm.exe" -ArgumentList "/config /syncfromflags:manual /manualpeerlist:`"$servers`""
Start-Process -wait -FilePath "w32tm.exe" -ArgumentList "/config /update"
Start-Process -wait -FilePath "w32tm" -ArgumentList "/resync"
$o = new-object -com shell.application
$currentPins = $o.Namespace('shell:::{679f85cb-0220-4080-b29b-5540cc05aab6}').Items() | ForEach-Object { $_.Path }
foreach ($path in @(
    [Environment]::GetFolderPath('MyVideos'),
    [Environment]::GetFolderPath('MyMusic')
)) {
    if ($currentPins -notcontains $path) {
        $o.Namespace($path).Self.InvokeVerb('pintohome')
    }
}
