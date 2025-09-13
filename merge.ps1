class mergedFile {
    [string]$name
    [array]$contentPaths

    mergedFile([hashtable]$Properties) { $this.Init($Properties) }
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

$mergedFiles = @(
    [mergedFile]::new(@{
            name         = "NitroWin.Tweaks.User.reg"
            contentPaths = (Get-ChildItem -Path "User" -Filter "*.reg" -Recurse)
        })
    [mergedFile]::new(@{
            name         = "NitroWin.Tweaks.User.ps1"
            contentPaths = (Get-ChildItem -Path "User" -Filter "*.ps1" -Recurse)
        })
    [mergedFile]::new(@{
            name         = "NitroWin.Tweaks.System.reg"
            contentPaths = (Get-ChildItem -Path "System" -Filter "*.reg" -Recurse)
        })
    [mergedFile]::new(@{
            name         = "NitroWin.Tweaks.System.ps1"
            contentPaths = (Get-ChildItem -Path "System" -Filter "*.ps1" -Recurse)
        })
)

foreach ($file in $mergedFiles) {
    if (Test-Path $file.name) {
        Remove-Item $file.name
    }

    if ($file.name.EndsWith(".reg")) {
        Add-Content -Path $file.name -Value "Windows Registry Editor Version 5.00"
        foreach ($contentPath in $file.contentPaths) {
            $content = Get-Content $contentPath.FullName
            Add-Content -Path $file.name -Value ($content | Select-Object -Skip 1)
        }
    }

    else {
        foreach ($contentPath in $file.contentPaths) {
            $content = Get-Content $contentPath.FullName
            Add-Content -Path $file.name -Value $content
        }
    }
}