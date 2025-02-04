. (Resolve-Path "$PSScriptRoot\..\assets.ps1").Path
. (Resolve-Path "$PSScriptRoot\elements\main-coverage-card.ps1").Path
. (Resolve-Path "$PSScriptRoot\elements\source-code.ps1").Path
. (Resolve-Path "$PSScriptRoot\elements\custom-css.ps1").Path
. (Resolve-Path "$PSScriptRoot\elements\sessioninfo.ps1").Path

function Render-SourcePage {
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
        [PSCustomObject]$sourcefile,
        [Parameter(Mandatory=$true)]
        [String]$sourceCode,
        [Parameter(Mandatory=$true)]
        [int]$directoryDepth
    )
    $result = $preloadedTemplates.'source'.Replace('<!--report.name-->', $pageName)

    $theme = $Global:jacocoxml2htmlConfig.theme
    $result = $result.Replace('<!--page.theme-->', $theme)
    $result = Render-AssetPath -template $result -asset 'css/bootstrap.min.css' -directoryDepth $directoryDepth
    if ($Global:jacocoxml2htmlConfig.source_page_custom_css) {
        $result = Render-CustomCSS -template $result -directoryDepth $directoryDepth -pageType "source"
    } else {
        $result = $result.Replace('<!--custom.css-->', '')
    }
    $result = Render-AssetPath -template $result -asset '<!--home.page.url-->' -directoryDepth $directoryDepth
    $result = $result.Replace('<!--home.page.url-->', 'index.html')
    $result = Render-AssetPath -template $result -asset 'highlightjs/build/styles/<!--source.code.theme-->' -directoryDepth $directoryDepth
    if ($theme -eq 'light') {
        $result = $result.Replace('<!--source.code.theme-->', $Global:jacocoxml2htmlConfig.source_code_theme_light)
        $result = $result.Replace('<!--line.number.yellow-->', $Global:jacocoxml2htmlConfig.line_number_yellow_light)
        $result = $result.Replace('<!--line.number.red-->', $Global:jacocoxml2htmlConfig.line_number_red_light)
        $result = $result.Replace('<!--line.number.green-->', $Global:jacocoxml2htmlConfig.line_number_green_light)
        $result = $result.Replace('<!--source.code.yellow-->', $Global:jacocoxml2htmlConfig.source_code_yellow_light)
        $result = $result.Replace('<!--source.code.red-->', $Global:jacocoxml2htmlConfig.source_code_red_light)
        $result = $result.Replace('<!--source.code.green-->', $Global:jacocoxml2htmlConfig.source_code_green_light)
    } else {
        $result = $result.Replace('<!--source.code.theme-->', $Global:jacocoxml2htmlConfig.source_code_theme_dark)
        $result = $result.Replace('<!--line.number.yellow-->', $Global:jacocoxml2htmlConfig.line_number_yellow_dark)
        $result = $result.Replace('<!--line.number.red-->', $Global:jacocoxml2htmlConfig.line_number_red_dark)
        $result = $result.Replace('<!--line.number.green-->', $Global:jacocoxml2htmlConfig.line_number_green_dark)
        $result = $result.Replace('<!--source.code.yellow-->', $Global:jacocoxml2htmlConfig.source_code_yellow_dark)
        $result = $result.Replace('<!--source.code.red-->', $Global:jacocoxml2htmlConfig.source_code_red_dark)
        $result = $result.Replace('<!--source.code.green-->', $Global:jacocoxml2htmlConfig.source_code_green_dark)
    }
    $result = Render-AssetPath -template $result -asset 'highlightjs/build/highlight.min.js' -directoryDepth $directoryDepth
    $result = Render-AssetPath -template $result -asset 'highlightjs-line-numbers/highlightjs-line-numbers.min.js' -directoryDepth $directoryDepth
    $result = Render-Sessioninfo -template $result -sessioninfoObject $sessioninfo

    $mainCardCounters = $sourcefile.counter
    $mainCoverageCard = Render-MainCoverageCard `
       -template $preloadedTemplates.'elements\main-coverage-card' `
       -cardTitle $mainCardTitle `
       -reportCounters $mainCardCounters
    $result = $result.Replace('<!--main coverage card-->', $mainCoverageCard)
    $result = $result.Replace('<!--sourcefile code block-->', $sourceCode)

    $result = Render-CoverageLineColors -template $result -sourcefile $sourcefile

    return $result
}