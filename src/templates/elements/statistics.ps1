. (Resolve-Path "$PSScriptRoot\counter.ps1").Path
. (Resolve-Path "$PSScriptRoot\..\..\utilities\string.ps1").Path
. (Resolve-Path "$PSScriptRoot\..\..\assets.ps1").Path

function Render-StatisticsRow {
    param (
        [Parameter(Mandatory=$true)]
        [String]$template,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$object,
        [Parameter(Mandatory=$true)]
        [int]$directoryDepth
    )

    $result = $template

    $name = $object.'@name'
    $pageLocation = "packages/$name.html"
    $result = $result.Replace('<!--page.location-->', $pageLocation)
    $result = $result.Replace('<!--item.name-->', $name)
    $result = $result.Replace('<!--classes.count-->', $object.'class'.Count)
    $result = $result.Replace('<!--sourcefiles.count-->', $object.sourcefile.Count)

    $result = Render-CounterRowData -template $result -counters $object.counter -counterType 'INSTRUCTION' -placeholder '<!--counter.instructions-->'
    $result = Render-CounterRowData -template $result -counters $object.counter -counterType 'BRANCH' -placeholder '<!--counter.branches-->'
    $result = Render-CounterRowData -template $result -counters $object.counter -counterType 'LINE' -placeholder '<!--counter.lines-->'
    $result = Render-CounterRowData -template $result -counters $object.counter -counterType 'METHOD' -placeholder '<!--counter.methods-->'
    $result = Render-CounterRowData -template $result -counters $object.counter -counterType 'CLASS' -placeholder '<!--counter.classes-->'
    $result = Render-CounterRowData -template $result -counters $object.counter -counterType 'COMPLEXITY' -placeholder '<!--counter.complexity-->'

    return $result
}

function Render-StatisticsCard {
    param (
        [Parameter(Mandatory=$true)]
        [String]$cardTemplate,
        [Parameter(Mandatory=$true)]
        [String]$rowTemplate,
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]$objects,
        [Parameter(Mandatory=$true)]
        [String]$cardTitle,
        [Parameter(Mandatory=$true)]
        [int]$directoryDepth
    )

    $result = $cardTemplate

    $result = $result.Replace('<!--page.theme-->', $Global:jacocoxml2htmlConfig.theme)

    foreach ($object in $objects) {
        $statisticsRow = Render-StatisticsRow `
            -template $rowTemplate `
            -object $object `
            -directoryDepth $directoryDepth
        $result = $result.Replace('<!--statistics rows-->', ($statisticsRow + "`n" + '<!--statistics rows-->'))
    }

    $result = $result.Replace('<!--statistics card title-->', $cardTitle)
    $result = Delete-LinesWithSubstrings -text $result -substrings @(,'<!--statistics rows-->')

    return $result
}
