. (Resolve-Path "$PSScriptRoot\elements\sessioninfo.ps1").Path
. (Resolve-Path "$PSScriptRoot\elements\main-coverage-card.ps1").Path
. (Resolve-Path "$PSScriptRoot\elements\statistics.ps1").Path
. (Resolve-Path "$PSScriptRoot\elements\sourcefiles.ps1").Path
. (Resolve-Path "$PSScriptRoot\elements\custom-css.ps1").Path
. (Resolve-Path "$PSScriptRoot\..\assets.ps1").Path

function Render-IndexPage {
    param (
        [Parameter(Mandatory=$true)]
        [String]$pageName,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$sessioninfo,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$preloadedTemplates,
        [Parameter(Mandatory=$true)]
        [String]$mainCardTitle,
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]$mainCardCounters,
        [Parameter(Mandatory=$false)]
        [PSCustomObject[]]$packages,
        [Parameter(Mandatory=$false)]
        [PSCustomObject[]]$groups,
        [Parameter(Mandatory=$false)]
        [PSCustomObject[]]$sourcefiles,
        [Parameter(Mandatory=$true)]
        [int]$directoryDepth
    )
    $result = $preloadedTemplates.'index' -replace '<!--report.name-->', $pageName

    $result = Render-AssetPath `
        -template $result `
        -asset '<!--home.page.url-->' `
        -directoryDepth $directoryDepth
    $result = $result.Replace('<!--home.page.url-->', 'index.html')
    $result = $result.Replace('<!--page.theme-->', $Global:jacocoxml2htmlConfig.theme)
    $result = Render-AssetPath `
        -template $result `
        -asset 'css/bootstrap.min.css' `
        -directoryDepth $directoryDepth
    if ($Global:jacocoxml2htmlConfig.group_page_custom_css) {
        $result = Render-CustomCSS -template $result -directoryDepth $directoryDepth -pageType "group"
    } else {
        $result = $result.Replace('<!--custom.css-->', '')
    }

    $result = Render-Sessioninfo `
        -template $result `
        -sessioninfoObject $sessioninfo
    $mainCoverageCard = Render-MainCoverageCard `
       -template $preloadedTemplates.'elements\main-coverage-card' `
       -cardTitle $mainCardTitle `
       -reportCounters $mainCardCounters
    $result = $result.Replace('<!--main coverage card-->', $mainCoverageCard)

    if ($null -ne $groups) {
        $groupsCard = Render-StatisticsCard `
            -cardTemplate $preloadedTemplates.'elements\statistics-card' `
            -rowTemplate $preloadedTemplates.'elements\statistics-card-row' `
            -objects $groups `
            -cardTitle 'Groups' `
            -directoryDepth $directoryDepth
        $result = $result.Replace('<!--groups-->', $groupsCard)
    } else {
        $result = $result.Replace('<!--groups-->', "")
    }

    if ($null -ne $packages) {
        $packagesCard = Render-StatisticsCard `
            -cardTemplate $preloadedTemplates.'elements\statistics-card' `
            -rowTemplate $preloadedTemplates.'elements\statistics-card-row' `
            -objects $packages `
            -cardTitle 'Packages' `
            -directoryDepth $directoryDepth
        $result = $result.Replace('<!--packages-->', $packagesCard)
    } else {
        $result = $result.Replace('<!--packages-->', "")
    }

    if ($null -ne $sourcefiles) {
        $sourcefilesCard = Render-SourcefilesCard `
            -cardTemplate $preloadedTemplates.'elements\sourcefiles-card' `
            -rowTemplate $preloadedTemplates.'elements\sourcefile-card-row' `
            -objects $sourcefiles `
            -cardTitle 'Source Code Files' `
            -directoryDepth $directoryDepth
        $result = $result.Replace('<!--sourcefiles-->', $sourcefilesCard)
    } else {
        $result = $result.Replace('<!--sourcefiles-->', "")
    }

    return $result
}