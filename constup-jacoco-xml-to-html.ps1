param (
    [Parameter(Mandatory=$true)]
    [String]$config
)

. (Resolve-Path "$PSScriptRoot/src/main.ps1").Path

Run-Flow -config $config