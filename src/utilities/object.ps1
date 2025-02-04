function Property-Exists {
    param (
        [Parameter(Mandatory=$true)]
        [PSObject]$object,
        [Parameter(Mandatory=$true)]
        [String]$name
    )

    if (Get-Member -InputObject $object -name $name -MemberType Properties) {
        return $true
    }

    return $false
}