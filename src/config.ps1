function Verify-Config {
    if ($null -eq $Global:jacocoxml2htmlConfig.xml_file -or '' -eq $Global:jacocoxml2htmlConfig.xml_file) {
        throw "'xml_file' configuration property is missing."
    }

    if ($null -eq $Global:jacocoxml2htmlConfig.destination_directory -or '' -eq $Global:jacocoxml2htmlConfig.destination_directory) {
        throw "'destination_directory' configuration property is missing."
    }

    if ($null -eq $Global:jacocoxml2htmlConfig.sources_directory -or '' -eq $Global:jacocoxml2htmlConfig.sources_directory) {
        throw "'sources_directory' configuration property is missing."
    }

    $validThemes = @('light', 'dark')
    if ( `
            $null -eq $Global:jacocoxml2htmlConfig.theme -or `
            '' -eq $Global:jacocoxml2htmlConfig.theme -or `
            (-not ($validThemes -contains $Global:jacocoxml2htmlConfig.theme))
    ) {
        throw "'theme' configuration property is missing or invalid. Valid values for 'theme': 'light', 'dark'."
    }
}

function Load-Config {
    param (
        [Parameter(Mandatory=$true)]
        [String]$configFileLocation
    )

    try
    {
        . (Resolve-Path "$PSScriptRoot/../default-config.ps1").Path
        $config = $Global:jacocoxml2htmlConfig
    } catch {
        throw "Default config failed to load."
    }

    try
    {
        . (Resolve-Path $configFileLocation).Path
    } catch {
        throw "Configuration file failed to laod."
    }

    $config.PSObject.Properties | ForEach-Object {
        if (-not ($Global:jacocoxml2htmlConfig.PSObject.Properties.Name -contains $_.Name)) {
            $Global:jacocoxml2htmlConfig | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
        }
    }
    Verify-Config -config $Global:jacocoxml2htmlConfig
}