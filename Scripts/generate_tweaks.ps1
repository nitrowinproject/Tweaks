class GeneratedFile {
    [string]$name
    [array]$contentPaths

    GeneratedFile([hashtable]$Properties) { $this.Init($Properties) }
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

$generatedFiles = @(
    [GeneratedFile]::new(@{
            name         = "NitroWin.Tweaks.User.reg"
            contentPaths = (Get-ChildItem -Path (Join-Path -Path "Tweaks" -ChildPath "User") -Filter "*.reg" -Recurse)
        })
    [GeneratedFile]::new(@{
            name         = "NitroWin.Tweaks.User.ps1"
            contentPaths = (Get-ChildItem -Path (Join-Path -Path "Tweaks" -ChildPath "User") -Filter "*.ps1" -Recurse)
        })
    [GeneratedFile]::new(@{
            name         = "NitroWin.Tweaks.System.reg"
            contentPaths = (Get-ChildItem -Path (Join-Path -Path "Tweaks" -ChildPath "System") -Filter "*.reg" -Recurse)
        })
    [GeneratedFile]::new(@{
            name         = "NitroWin.Tweaks.System.ps1"
            contentPaths = (Get-ChildItem -Path (Join-Path -Path "Tweaks" -ChildPath "System") -Filter "*.ps1" -Recurse)
        })
)

if (-Not (Test-Path -Path "Generated")) {
    New-Item -Path "Generated" -ItemType Directory
}

foreach ($file in $generatedFiles) {
    $generatedFilePath = Join-Path -Path "Generated" -ChildPath $file.name

    if (Test-Path $generatedFilePath) {
        Remove-Item $generatedFilePath
    }

    if ($file.name.EndsWith(".reg")) {
        Add-Content -Path $generatedFilePath -Value "Windows Registry Editor Version 5.00"
        foreach ($contentPath in $file.contentPaths) {
            $content = Get-Content $contentPath.FullName
            Add-Content -Path $generatedFilePath -Value ($content | Select-Object -Skip 1)
        }
    }

    else {
        foreach ($contentPath in $file.contentPaths) {
            $content = Get-Content $contentPath.FullName
            Add-Content -Path $generatedFilePath -Value $content
        }
    }
}