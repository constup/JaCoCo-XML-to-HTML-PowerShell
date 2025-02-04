function Render-Sessioninfo {
    param (
        [Parameter(Mandatory=$true)]
        [String]$template,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$sessioninfoObject
    )

    if ([long]$sessioninfoObject.'@start' -ge 10000000000) {
        $duration = ([long]$sessioninfoObject.'@dump' - [long]$sessioninfoObject.'@start') / 1000
        $start = Get-Date -UFormat "%d/%m/%Y %R:%S" -UnixTimeSeconds ([Math]::Round([long]$sessioninfoObject.'@start' / 1000))
        $dump = Get-Date -UFormat "%d/%m/%Y %R:%S" -UnixTimeSeconds ([Math]::Round([long]$sessioninfoObject.'@dump' / 1000))
    } else {
        $duration = [long]$sessioninfoObject.'@dump' - [long]$sessioninfoObject.'@start'
        $start = Get-Date -UFormat "%d/%m/%Y %R:%S" -UnixTimeSeconds $sessioninfoObject.'@start'
        $dump = Get-Date -UFormat "%d/%m/%Y %R:%S" -UnixTimeSeconds $sessioninfoObject.'@dump'
    }

    $result = $template
    if ($sessioninfoObject.'@id' -ne "")
    {
        $sessioninfoIdText = $sessioninfoObject.'@id' + ' '
        $result = $result.Replace('<!--sessioninfo.id-->', $sessioninfoIdText)
    }
    $result = $result.Replace('<!--sessioninfo.start-->', $start)
    $result = $result.Replace('<!--sessioninfo.dump-->', $dump)
    $result = $result.Replace('<!--sessioninfo.duration-->', $duration)

    return $result
}