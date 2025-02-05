. (Resolve-Path "$PSScriptRoot\config.ps1").Path
. (Resolve-Path "$PSScriptRoot\assets.ps1").Path
. (Resolve-Path "$PSScriptRoot\render.ps1").Path
. (Resolve-Path "$PSScriptRoot\xml-reader.ps1").Path
. (Resolve-Path "$PSScriptRoot\templates\templates.ps1").Path

function Write-Version {
    $version = Get-Content -Raw -Path (Resolve-Path "$PSScriptRoot\..\version").Path
    Write-Host "constUP JaCoCo XML to HTML Code Coverage Report Generator $version"
    Write-Host "=========="
    Write-Host ""
}

function Load-Configuration {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$config
    )

    Write-Host "    Loading configuration..."
    Load-Config -configFileLocation $config
    Write-Host "        Configuration loaded."
}

function Check-XmlFile {
    param(
        [Parameter(Mandatory=$true)]
        [String]$xmlFile
    )
    Write-Host '    Checking XML file...'
    if (-Not (Test-Path $xmlFile)) {
        Write-Error "XML file $xmlFile either does not exist or can not be read."
        exit 1
    }
    Write-Host '        XML file is present.'
}

function Check-DestinationDirectory {
    param(
        [Parameter(Mandatory=$true)]
        [String]$destinationDirectory
    )
    Write-Host '    Checking destination directory...'
    if (-Not (Test-Path $destinationDirectory)) {
        try {
            New-Item -ItemType Directory -Path $destinationDirectory -Force > $null
        }
        catch
        {
            Write-Error "Invalid destination directory or directory can not be created."
            exit 1
        }
    } else {
        if ((Get-ChildItem -Path $destinationDirectory | Measure-Object).Count -ne 0) {
            throw "Destination directory is not empty."
            exit 1
        }
    }
    Write-Host '        Destination directory is ready.'
}

function Create-BaseTemplates {
    param(
        [Parameter(Mandatory=$true)]
        [String]$destinationDirectory
    )

    Write-Host '    Creating base template assets...'
    try {
        Copy-Assets -destinationDirectory $destinationDirectory
        Set-Content -Path "$destinationDirectory/index.html" -Value ""
    } catch {
        Write-Error "There was a problem while trying to write base template files in: $destinationDirectory"
        exit 1
    }
    Write-Host '        Base template assets are ready.'
}

function Render-AllFiles {
    param(
        [Parameter(Mandatory=$true)]
        [String]$xmlFile,
        [Parameter(Mandatory=$true)]
        [String]$destinationDirectory,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$xmlObject,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$preloadedTemplates,
        [Parameter(Mandatory=$true)]
        [String]$sourcesDirectory
    )

    Write-Host '    Rendering files...'
    Render-Files `
    -destinationDirectory $destinationDirectory `
    -xmlObject $xmlObject `
    -preloadedTemplates $preloadedTemplates `
    -sourcesDirectory $sourcesDirectory
    Write-Host '        All files are rendered.'
    Write-Host ''
}

function Run-Flow {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$config
    )

    Write-Version
    Load-Configuration -config $config
    $xmlFile = $Global:jacocoxml2htmlConfig.xml_file
    $destinationDirectory = $Global:jacocoxml2htmlConfig.destination_directory
    $sourcesDirectory = $Global:jacocoxml2htmlConfig.sources_directory
    Check-XmlFile -xmlFile $xmlFile
    Check-DestinationDirectory -destinationDirectory $destinationDirectory
    Create-BaseTemplates -destinationDirectory $destinationDirectory
    $preloadedTemplates = Preload-Templates
    $xmlObject = Read-XML -filePath $xmlFile
    Render-AllFiles `
    -xmlFile $xmlFile `
    -destinationDirectory $destinationDirectory `
    -xmlObject $xmlObject `
    -preloadedTemplates $preloadedTemplates `
    -sourcesDirectory $sourcesDirectory
    Write-Host "HTML coverage report has been successfully generated."
}
