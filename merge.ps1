$mergedRegistryUserFile = "NitroWin.Tweaks.User.reg"
$mergedBatchUserFile = "NitroWin.Tweaks.User.bat"
$mergedPowerShellUserFile = "NitroWin.Tweaks.User.ps1"

$mergedRegistrySystemFile = "NitroWin.Tweaks.System.reg"
$mergedBatchSystemFile = "NitroWin.Tweaks.System.bat"
$mergedPowerShellSystemFile = "NitroWin.Tweaks.System.ps1"


if (Test-Path $mergedRegistryUserFile) {
    Remove-Item $mergedRegistryUserFile
}

if (Test-Path $mergedBatchUserFile) {
    Remove-Item $mergedBatchUserFile
}

if (Test-Path $mergedPowerShellUserFile) {
    Remove-Item $mergedPowerShellUserFile
}


if (Test-Path $mergedRegistrySystemFile) {
    Remove-Item $mergedRegistrySystemFile
}

if (Test-Path $mergedBatchSystemFile) {
    Remove-Item $mergedBatchSystemFile
}

if (Test-Path $mergedPowerShellSystemFile) {
    Remove-Item $mergedPowerShellSystemFile
}


$registryTweakUserFiles = Get-ChildItem -Path "User" -Filter "*.reg" -Recurse
$batchTweakUserFiles = Get-ChildItem -Path "User" -Filter "*.bat" -Recurse
$powershellTweakUserFiles = Get-ChildItem -Path "User" -Filter "*.ps1" -Recurse

$registryTweakSystemFiles = Get-ChildItem -Path "System" -Filter "*.reg" -Recurse
$batchTweakSystemFiles = Get-ChildItem -Path "System" -Filter "*.bat" -Recurse
$powershellTweakSystemFiles = Get-ChildItem -Path "System" -Filter "*.ps1" -Recurse


Add-Content -Path $mergedRegistryUserFile -Value "Windows Registry Editor Version 5.00"

foreach ($file in $registryTweakUserFiles) {
    $content = Get-Content $file.FullName
    Add-Content -Path $mergedRegistryUserFile -Value ($content | Select-Object -Skip 1)
}

foreach ($file in $batchTweakUserFiles) {
    $content = Get-Content $file.FullName
    Add-Content -Path $mergedBatchUserFile -Value $content
}

foreach ($file in $powershellTweakUserFiles) {
    $content = Get-Content $file.FullName
    Add-Content -Path $mergedPowerShellUserFile -Value $content
}

Add-Content -Path $mergedRegistrySystemFile -Value "Windows Registry Editor Version 5.00"

foreach ($file in $registryTweakSystemFiles) {
    $content = Get-Content $file.FullName
    Add-Content -Path $mergedRegistrySystemFile -Value ($content | Select-Object -Skip 1)
}

foreach ($file in $batchTweakSystemFiles) {
    $content = Get-Content $file.FullName
    Add-Content -Path $mergedBatchSystemFile -Value $content
}

foreach ($file in $powershellTweakSystemFiles) {
    $content = Get-Content $file.FullName
    Add-Content -Path $mergedPowerShellSystemFile -Value $content
}