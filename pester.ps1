$config = New-PesterConfiguration
$config.TestDrive.Enabled = $true
$config.TestRegistry.Enabled = $true
$config.Run.Path = "./tests"
$config.CodeCoverage.RecursePaths = $true
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.Path = './src'
$config.CodeCoverage.OutputPath = './coverage/coverage.xml'
$config.CodeCoverage.OutputFormat = 'JaCoCo'

Invoke-Pester -Configuration $config
. ("$PSScriptRoot\config.ps1")
if (Test-Path -Path $Global:jacocoxml2htmlConfig.destination_directory) {
    Remove-Item -Path $Global:jacocoxml2htmlConfig.destination_directory -Recurse -Force
}
& .\constup-jacoco-xml-to-html.ps1 -config .\config.ps1