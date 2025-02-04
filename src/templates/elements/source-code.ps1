. (Resolve-Path "$PSScriptRoot\..\..\utilities\object.ps1").Path
. (Resolve-Path "$PSScriptRoot\..\..\utilities\string.ps1").Path

function Prepare-CoverageLineColors {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$sourcefile
    )

    if (Property-Exists -object $sourcefile -name 'line') {
        $result = New-Object System.Collections.Generic.List[Object]
        $yellowLines = New-Object System.Collections.Generic.List[String]
        $redLines = New-Object System.Collections.Generic.List[String]
        $greenLines = New-Object System.Collections.Generic.List[String]

        $lines = $sourcefile.line
        foreach ($line in $lines) {
            if ([int]$line.'@mi' -gt 0) {
                if ([int]$line.'@ci' -gt 0) {
                    $yellowLines.Add($line.'@nr')
                } else {
                    $redLines.Add($line.'@nr')
                }
            } else {
                $greenLines.Add($line.'@nr')
            }
        }

        $result.Add($yellowLines)
        $result.Add($redLines)
        $result.Add($greenLines)

        return $result
    }

    return $null
}

function Render-CoverageLineColors {
    param(
        [Parameter(Mandatory=$true)]
        [String]$template,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$sourcefile
    )

    $lineColors = Prepare-CoverageLineColors -sourcefile $sourcefile
    if ($null -ne $lineColors) {
        $yellowLines = $lineColors[0] -join ', '
        $redLines = $lineColors[1] -join ', '
        $greenLines = $lineColors[2] -join ', '

        $result = $template.Replace('<!--yellow.lines-->', $yellowLines)
        $result = $result.Replace('<!--red.lines-->', $redLines)
        $result = $result.Replace('<!--green.lines-->', $greenLines)
    } else {
        $result = Delete-LinesWithSubstrings -text $template -substrings @('<!--yellow.lines-->', '<!--red.lines-->', '<!--green.lines-->')
    }

    return $result
}