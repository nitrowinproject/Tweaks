$mergedRegistryFile = "NitroWin.Tweaks.reg"
$mergedBatchFile = "NitroWin.Tweaks.bat"
$mergedPowerShellFile = "NitroWin.Tweaks.ps1"

if (Test-Path $mergedRegistryFile) {
    Remove-Item $mergedRegistryFile
}

if (Test-Path $mergedBatchFile) {
    Remove-Item $mergedBatchFile
}

if (Test-Path $mergedPowerShellFile) {
    Remove-Item $mergedPowerShellFile
}

$registryTweakFiles = Get-ChildItem -Path (Get-Location) -Filter "*.reg" -Recurse
$batchTweakFiles = Get-ChildItem -Path (Get-Location) -Filter "*.bat" -Recurse
$powershellTweakFiles = Get-ChildItem -Path (Get-Location) -Filter "*.ps1" -Recurse | Where-Object { $_.Name -ne 'merge.ps1' }

Add-Content -Path $mergedRegistryFile -Value "Windows Registry Editor Version 5.00"

foreach ($file in $registryTweakFiles) {
    $content = Get-Content $file.FullName
    Add-Content -Path $mergedRegistryFile -Value ($content | Select-Object -Skip 1)
}

foreach ($file in $batchTweakFiles) {
    $content = Get-Content $file.FullName
    Add-Content -Path $mergedBatchFile -Value $content
}

foreach ($file in $powershellTweakFiles) {
    $content = Get-Content $file.FullName
    Add-Content -Path $mergedPowerShellFile -Value $content
}