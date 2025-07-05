Write-Host "Adding Recycle Bin to Home..."

try {
    $RBPath = 'HKCU:\Software\Classes\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\pintohome\command\'
    $name = "DelegateExecute"
    $value = "{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}"
    New-Item -Path $RBPath -Force | out-null
    New-ItemProperty -Path $RBPath -Name $name -Value $value -PropertyType String -Force | out-null
    $oShell = New-Object -ComObject Shell.Application
    $trash = $oShell.Namespace("shell:::{645FF040-5081-101B-9F08-00AA002F954E}")
    $trash.Self.InvokeVerb("PinToHome")
    Remove-Item -Path "HKCU:\Software\Classes\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}" -Recurse

    Write-Host "Recycle Bin has been added to Home" -ForegroundColor Green
}
catch {
    Write-Host "Failed to add Recycle Bin to Home: $_" -ForegroundColor Red
}