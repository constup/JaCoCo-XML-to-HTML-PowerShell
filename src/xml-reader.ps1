function Read-XML {
    param (
        [Parameter(Mandatory=$true)]
        [String]$filePath
    )

    if (-not (Test-Path -Path $filePath)) {
        throw "Coverage XML file not found."
    }

    [xml]$xml = Get-Content $filePath
    $json = [Newtonsoft.Json.JsonConvert]::SerializeXmlNode($xml, 'Indented')
    $result = $json | ConvertFrom-Json -Depth 100

    return $result
}