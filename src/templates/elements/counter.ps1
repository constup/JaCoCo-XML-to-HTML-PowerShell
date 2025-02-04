function Render-CounterRowData {
    param (
        [Parameter(Mandatory=$true)]
        [String]$template,
        [Parameter(Mandatory=$true)]
        [Array]$counters,
        [Parameter(Mandatory=$true)]
        [String]$counterType,
        [Parameter(Mandatory=$true)]
        [String]$placeholder
    )

    $result = $template

    $counter = $counters | Where-Object { $_.'@type' -eq $counterType }
    if ($counter) {
        if ($counter.'@type' -eq 'INSTRUCTION' -and [long]$counter.'@missed' -eq 0) {
            if ($Global:jacocoxml2htmlConfig.theme -eq 'light') {
                $color = $Global:jacocoxml2htmlConfig.source_code_green_light
            } else {
                $color = $Global:jacocoxml2htmlConfig.source_code_green_dark
            }
            $result = $result.Replace('<!--100.percent-->', "style=`"background-color: $color;`"")
        } else {
            $result = $result.Replace('<!--100.percent-->', '')
        }
        $total = [long]$counter.'@covered' + [long]$counter.'@missed'
        $percent = ([long]$counter.'@covered' / $total) * 100
        $percent = "{0:N2}" -f $percent
        $replacementText = "{0} - {1} - {2} - {3}%" -f $counter.'@missed', $counter.'@covered', $total, $percent
        $result = $result.Replace($placeholder, $replacementText)
    } else {
        $result = $result.Replace($placeholder, "")
    }

    return $result
}