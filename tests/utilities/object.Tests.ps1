Describe 'Property-Exists' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\src\utilities\object.ps1").Path
    }

    It 'Should return true' {
        $object = [PSCustomObject]@{
            'existing_property' = 'lorem ipsum';
        }
        $result = Property-Exists -object $object -name 'existing_property'
        $result | Should -Be $true
    }
    It 'Should return false' {
        $object = [PSCustomObject]@{
            'existing_property' = 'lorem ipsum';
        }
        $result = Property-Exists -object $object -name 'non_existing_property'
        $result | Should -Be $false
    }
}