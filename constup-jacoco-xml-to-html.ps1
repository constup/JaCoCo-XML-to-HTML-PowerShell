param (
    [Parameter(Mandatory=$true)]
    [String]$config
)

& .\src\main.ps1 -config $config