Describe 'Read-XML' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\src\xml-reader.ps1").Path
    }

    It 'Should throw an error sayig that the coverage file was not found.' {
        Mock -CommandName Test-Path -MockWith {
            param($Path)

            return $false
        }

        { Read-XML -filePath 'sample' } | Should -Throw -ExpectedMessage "Coverage XML file not found."
    }
}