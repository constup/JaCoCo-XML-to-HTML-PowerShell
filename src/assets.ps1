function Copy-Assets {
    param (
        [Parameter(Mandatory=$true)]
        [String]$destinationDirectory
    )

    New-Item -ItemType Directory -Path "$destinationDirectory\css" -Force > $null
    $path = (Resolve-Path "$PSScriptRoot\..\assets\bootstrap\css\bootstrap.min.css").Path
    Copy-Item -Path $path -Destination "$destinationDirectory\css\bootstrap.min.css"

    $path = (Resolve-Path "$PSScriptRoot\..\assets\highlightjs").Path
    Copy-Item -Path $path -Destination "$destinationDirectory\highlightjs" -Recurse -Force

    $path = (Resolve-Path "$PSScriptRoot\..\assets\highlightjs-line-numbers").Path
    Copy-Item -Path $path -Destination "$destinationDirectory\highlightjs-line-numbers" -Recurse -Force

    if ($Global:jacocoxml2htmlConfig.group_page_custom_css) {
        $path = (Resolve-Path $Global:jacocoxml2htmlConfig.group_page_custom_css).Path
        Copy-Item -Path $path -Destination "$destinationDirectory\css\group_page_custom.css"
    }

    if ($Global:jacocoxml2htmlConfig.source_page_custom_css) {
        $path = (Resolve-Path $Global:jacocoxml2htmlConfig.source_page_custom_css).Path
        Copy-Item -Path $path -Destination "$destinationDirectory\css\source_page_custom.css"
    }
}

function Render-AssetPath {
    param (
        [Parameter(Mandatory=$true)]
        [String]$template,
        [Parameter(Mandatory=$true)]
        [String]$asset,
        [Parameter(Mandatory=$true)]
        [int]$directoryDepth
    )

    $result = $template

    if ($directoryDepth -ne 0) {
        $assetPath = ""
        for ($i = 1; $i -le $directoryDepth; $i++) {
            $assetPath = '../' + $assetPath
        }
        $result = $result.Replace($asset, ("$assetPath" + $asset))
    }

    return $result
}