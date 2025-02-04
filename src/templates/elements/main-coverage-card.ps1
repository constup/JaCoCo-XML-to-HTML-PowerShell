. (Resolve-Path "$PSScriptRoot\..\..\utilities\string.ps1").Path

function Render-MainCoverageCardCounter {
    param (
        [Parameter(Mandatory=$true)]
        [String]$template,
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]$reportCounters,
        [Parameter(Mandatory=$true)]
        [String]$counterType,
        [Parameter(Mandatory=$true)]
        [String]$placeholder
    )

    $result = $template

    $result = $result.Replace('<!--page.theme-->', $Global:jacocoxml2htmlConfig.theme)

    $counter = $reportCounters | Where-Object { $_.'@type' -eq $counterType }
    if ($counter) {
        $total = [long]$counter.'@covered' + [long]$counter.'@missed'
        $percent = ([long]$counter.'@covered' / $total) * 100
        $percent = "{0:N2}" -f $percent
        $result = $result.Replace("<!--$placeholder.covered-->", $counter.'@covered')
        $result = $result.Replace("<!--$placeholder.missed-->", $counter.'@missed')
        $result = $result.Replace("<!--$placeholder.total-->", $total)
        $result = $result.Replace("<!--$placeholder.percent-->", $percent)
    } else {
        $result = Delete-LinesWithSubstrings -text $result -substrings @(,$placeholder)
    }

    return $result
}

function Render-MainCoverageCard {
    param (
        [Parameter(Mandatory=$true)]
        [String]$template,
        [Parameter(Mandatory=$true)]
        [String]$cardTitle,
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]$reportCounters
    )

    $processedTemplate = $template

    $processedTemplate = $processedTemplate -replace '<!--card title-->', $cardTitle
    $processedTemplate = Render-MainCoverageCardCounter -template $processedTemplate -reportCounters $reportCounters -counterType 'INSTRUCTION' -placeholder 'report.counter.instructions'
    $processedTemplate = Render-MainCoverageCardCounter -template $processedTemplate -reportCounters $reportCounters -counterType 'BRANCH' -placeholder 'report.counter.branches'
    $processedTemplate = Render-MainCoverageCardCounter -template $processedTemplate -reportCounters $reportCounters -counterType 'LINE' -placeholder 'report.counter.lines'
    $processedTemplate = Render-MainCoverageCardCounter -template $processedTemplate -reportCounters $reportCounters -counterType 'METHOD' -placeholder 'report.counter.methods'
    $processedTemplate = Render-MainCoverageCardCounter -template $processedTemplate -reportCounters $reportCounters -counterType 'CLASS' -placeholder 'report.counter.classes'
    $processedTemplate = Render-MainCoverageCardCounter -template $processedTemplate -reportCounters $reportCounters -counterType 'COMPLEXITY' -placeholder 'report.counter.complexity'

    return $processedTemplate
}