Write-Host "Adding Music and Videos to Home..." -ForegroundColor DarkGray

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
Write-Host "Adding Recycle Bin to Home..." -ForegroundColor DarkGray

try {
    $RBPath = 'HKCU:\Software\Classes\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\pintohome\command\'
    $name = "DelegateExecute"
    $value = "{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}"
    New-Item -Path $RBPath -Force | Out-Null
    New-ItemProperty -Path $RBPath -Name $name -Value $value -PropertyType String -Force | Out-Null
    $oShell = New-Object -ComObject Shell.Application
    $trash = $oShell.Namespace("shell:::{645FF040-5081-101B-9F08-00AA002F954E}")
    $trash.Self.InvokeVerb("PinToHome")
    Remove-Item -Path "HKCU:\Software\Classes\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}" -Recurse

    Write-Host "Recycle Bin has been added to Home!" -ForegroundColor Green
} catch {
    Write-Host "Failed to add Recycle Bin to Home: $_" -ForegroundColor Red
}
