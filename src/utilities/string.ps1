function Delete-LinesWithSubstrings {
    param (
        [Parameter(Mandatory=$true)]
        [String]$text,
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[String]]$substrings
    )

    $normalizedText = $text.Replace("`r`n", "`n")
    $lines = $normalizedText -split "`n"

    foreach ($substring in $substrings) {
        $lines = $lines | Where-Object { $_ -notmatch $substring }
    }

    $lines = $lines | ForEach-Object { $_.TrimEnd('\r') }
    $result = $lines -join "`n"

    return $result
}