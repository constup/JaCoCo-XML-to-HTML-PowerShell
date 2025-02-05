. (Join-Path $PSScriptRoot ./xml-reader.ps1)
. (Join-Path $PSScriptRoot ./assets.ps1)
. (Join-Path $PSScriptRoot ./templates/elements/sessioninfo.ps1)
. (Join-Path $PSScriptRoot ./templates/elements/main-coverage-card.ps1)
. (Join-Path $PSScriptRoot ./templates/elements/counter.ps1)
. (Join-Path $PSScriptRoot ./templates/templates.ps1)
. (Join-Path $PSScriptRoot ./templates/index-page.ps1)
. (Join-Path $PSScriptRoot ./templates/source-page.ps1)
. (Join-Path $PSScriptRoot ./utilities/string.ps1)
. (Join-Path $PSScriptRoot ./utilities/object.ps1)

function Render-Groups {
    param (
        [Parameter(Mandatory=$true)]
        [PsCustomObject[]]$groups,
        [Parameter(Mandatory=$true)]
        [String]$destinationDirectory,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$xmlObject,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$preloadedTemplates,
        [Parameter(Mandatory=$true)]
        [String]$sourcesDirectory
    )

    foreach ($group in $groups) {
        $groupName = $group.'@name'
        $destination = "$destinationDirectory/groups/$groupName.html"
        $directoryDepth = ($destination -split '[\\/]').Count - ($destinationDirectory -split '[\\/]').Count - 1

        $content = Render-IndexPage `
            -pageName $xmlObject.report.'@name' `
            -sessioninfo $xmlObject.report.sessioninfo `
            -preloadedTemplates $preloadedTemplates `
            -mainCardTitle "Group Coverage for: <strong>$groupName</strong>" `
            -mainCardCounters $group.counter `
            -directoryDepth $directoryDepth

        $directoryName = [System.IO.Path]::GetDirectoryName($destination)
        if (-not (Test-Path -Path $directoryName)) {
            New-Item -ItemType Directory -Path $directoryName -Force > $null
        }
        Set-Content -Path "$destination" -Value $content -Force

        if (Property-Exists -object $group -name 'group') {
            Render-Groups `
                -groups $group.group `
                -destinationDirectory $destinationDirectory `
                -xmlObject $xmlObject `
                -preloadedTemplates $preloadedTemplates `
                -sourcesDirectory $sourcesDirectory
        }

        if (Property-Exists -object $group -name 'package') {
            Render-Packages `
                -packages $group.package `
                -destinationDirectory $destinationDirectory `
                -xmlObject $xmlObject `
                -preloadedTemplates $preloadedTemplates `
                -sourcesDirectory $sourcesDirectory
        }

    }
}

function Render-Sourcefiles {
    param (
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]$sourcefiles,
        [Parameter(Mandatory=$true)]
        [String]$destinationDirectory,
        [Parameter(Mandatory=$true)]
        [String]$sourcesDirectory,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$xmlObject,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$preloadedTemplates
    )
    foreach ($sourcefile in $sourcefiles) {
        $sourcefileName = $sourcefile.'@name'
        $destination = "$destinationDirectory/sources/$sourcefileName.html"
        $directoryDepth = ($destination -split '[\\/]').Count - ($destinationDirectory -split '[\\/]').Count - 1
        $sourceCodePath = (Resolve-Path "$sourcesDirectory/$sourcefileName").Path
        $sourceCode = Get-Content -Raw -Path $sourceCodePath
        Add-Type -AssemblyName System.Web
        $sourceCode = [System.Web.HttpUtility]::HtmlEncode($sourceCode)

        $content = Render-SourcePage `
            -pageName $xmlObject.report.'@name' `
            -sessioninfo $xmlObject.report.sessioninfo `
            -preloadedTemplates $preloadedTemplates `
            -mainCardTitle "Source Code Coverage for: <strong>$sourcefileName</strong>" `
            -sourcefile $sourcefile `
            -sourceCode $sourceCode `
            -directoryDepth $directoryDepth

        $directoryName = [System.IO.Path]::GetDirectoryName($destination)
        if (-not (Test-Path -Path $directoryName)) {
            New-Item -ItemType Directory -Path $directoryName -Force > $null
        }
        Set-Content -Path "$destination" -Value $content -Force
    }
}

function Render-Packages {
    param (
        [Parameter(Mandatory=$true)]
        [PsCustomObject[]]$packages,
        [Parameter(Mandatory=$true)]
        [String]$destinationDirectory,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$xmlObject,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$preloadedTemplates,
        [Parameter(Mandatory=$true)]
        [String]$sourcesDirectory
    )

    foreach ($package in $packages) {
        $packageName = $package.'@name'
        $destination = "$destinationDirectory/packages/$packageName.html"
        $directoryDepth = ($destination -split '[\\/]').Count - ($destinationDirectory -split '[\\/]').Count - 1

        $content = Render-IndexPage `
            -pageName $xmlObject.report.'@name' `
            -sessioninfo $xmlObject.report.sessioninfo `
            -preloadedTemplates $preloadedTemplates `
            -mainCardTitle "Package Coverage for: <strong>$packageName</strong>" `
            -mainCardCounters $package.counter `
            -directoryDepth $directoryDepth `
            -sourcefiles $package.sourcefile

        $directoryName = [System.IO.Path]::GetDirectoryName($destination)
        if (-not (Test-Path -Path $directoryName)) {
            New-Item -ItemType Directory -Path $directoryName -Force > $null
        }
        Set-Content -Path "$destination" -Value $content -Force

        if (Property-Exists -object $package -name 'sourcefile') {
            $sourcefiles = $package.sourcefile
            Render-Sourcefiles `
                -sourcefiles $sourcefiles `
                -destinationDirectory $destinationDirectory `
                -sourcesDirectory $sourcesDirectory `
                -xmlObject $xmlObject `
                -preloadedTemplates $preloadedTemplates
        }
    }
}

function Render-Files {
    param (
        [Parameter(Mandatory=$true)]
        [String]$destinationDirectory,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$xmlObject,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$preloadedTemplates,
        [Parameter(Mandatory=$true)]
        [String]$sourcesDirectory
    )

    $content = Render-IndexPage `
                -pageName $xmlObject.report.'@name' `
                -sessioninfo $xmlObject.report.sessioninfo `
                -preloadedTemplates $preloadedTemplates `
                -mainCardTitle 'Project Coverage' `
                -mainCardCounters $xmlObject.report.counter `
                -packages $xmlObject.report.package `
                -groups $xmlObject.report.group `
                -directoryDepth 0
    Set-Content -Path "$destinationDirectory/index.html" -Value $content

    if (Property-Exists -object $xmlObject.report -name 'group') {
        Render-Groups `
                -groups $xmlObject.report.group `
                -destinationDirectory $destinationDirectory `
                -xmlObject $xmlObject `
                -preloadedTemplates $preloadedTemplates `
                -sourcesDirectory $sourcesDirectory
    }

    if (Property-Exists -object $xmlObject.report -name 'package') {
        $result = Render-Packages `
                    -packages $xmlObject.report.package `
                    -destinationDirectory $destinationDirectory `
                    -xmlObject $xmlObject `
                    -preloadedTemplates $preloadedTemplates `
                    -sourcesDirectory $sourcesDirectory
    }
}