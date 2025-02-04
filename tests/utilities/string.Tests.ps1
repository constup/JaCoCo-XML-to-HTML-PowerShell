Describe 'Delete-LinesWithSubstrings' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\src\utilities\string.ps1").Path

        $Global:text = @'
This is line one.
This is line two.
This is line three.
'@
    }

    It 'Should delete multiple lines.' {
        $expected = @'
This is line two.
'@
        $expected = $expected -replace "`r`n", "`n"
        $substrings = New-Object System.Collections.Generic.List[String]
        $substrings.Add('line one')
        $substrings.Add('line three')

        $result = Delete-LinesWithSubstrings -text $text -substrings $substrings
        $result | Should -Be $expected
    }

    It 'Should delete one line.' {
        $expected= @'
This is line one.
This is line three.
'@
        $expected = $expected -replace "`r`n", "`n"
        $substrings = New-Object System.Collections.Generic.List[String]
        $substrings.Add('line two')

        $result = Delete-LinesWithSubstrings -text $text -substrings $substrings
        $result | Should -Be $expected
    }

    It 'Should not delete any line' {
        $expected = $text

        $expected = $expected -replace "`r`n", "`n"
        $substrings = New-Object System.Collections.Generic.List[String]
        $substrings.Add('line four')
        $substrings.Add('line five')

        $result = Delete-LinesWithSubstrings -text $text -substrings $substrings
        $result | Should -Be $expected
    }
}