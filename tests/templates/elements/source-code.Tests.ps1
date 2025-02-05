Describe 'Prepare-CoverageLineColors' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\source-code.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\utilities\string.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\utilities\object.ps1").Path
    }

    Context 'Error' {
        It 'Should return $null' {
            $sourceFile = [PSCustomObject]@{
                'something_other_than_line' = 'lorem ipsum';
            }

            $result = Prepare-CoverageLineColors -sourceFile $sourceFile
            $result | Should -Be $null
        }
    }

    Context 'Happy flow' {
        It 'Should prepare color arrays for specified set of lines' {
            $sourceFile = [PSCustomObject]@{
                'line' = [PSCustomObject[]]@(
                    # yellow
                    [PSCustomObject]@{
                        '@nr' = '1';
                        '@mi' = '6';
                        '@ci' = '3';
                        '@mb' = '0';
                        '@cb' = '0';
                    },
                    # green
                    [PSCustomObject]@{
                        '@nr' = '2';
                        '@mi' = '0';
                        '@ci' = '3';
                        '@mb' = '0';
                        '@cb' = '0';
                    },
                    # red
                    [PSCustomObject]@{
                        '@nr' = '3';
                        '@mi' = '6';
                        '@ci' = '0';
                        '@mb' = '0';
                        '@cb' = '0';
                    }
                )
            }
            $yellowLines = New-Object System.Collections.Generic.List[String]
            $yellowLines.Add('1')
            $greenLines = New-Object System.Collections.Generic.List[String]
            $greenLines.Add('2')
            $redLines = New-Object System.Collections.Generic.List[String]
            $redLines.Add('3')
            $expected = New-Object System.Collections.Generic.List[Object]
            $expected.Add($yellowLines)
            $expected.Add($redLines)
            $expected.Add($greenLines)

            $result = Prepare-CoverageLineColors -sourceFile $sourceFile
            $result | Should -Be $expected
        }
    }
}

Describe 'Render-CoverageLineColors' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\source-code.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\utilities\string.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\utilities\object.ps1").Path
    }

    Context 'Error' {
        It 'Should remove line coloring JS' {
            $template = @'
something
highlightLines([<!--yellow.lines-->], '<!--line.number.yellow-->', '<!--source.code.yellow-->');
highlightLines([<!--red.lines-->], '<!--line.number.red-->', '<!--source.code.red-->');
highlightLines([<!--green.lines-->], '<!--line.number.green-->', '<!--source.code.green-->');
something else
'@
            $template = $template.Replace("`r`n", "`n")
            $expected = @'
something
something else
'@
            $expected = $expected.Replace("`r`n", "`n")

            $sourceFile = [PSCustomObject]@{
                'something_other_than_line' = 'lorem ipsum';
            }

            $result = Render-CoverageLineColors -template $template -sourcefile $sourceFile
            $result | Should -Be $expected
        }
    }

    Context 'Happy flow' {
        It 'Should include yellow, red and green lines' {
            $template = @'
something
highlightLines([<!--yellow.lines-->], '<!--line.number.yellow-->', '<!--source.code.yellow-->');
highlightLines([<!--red.lines-->], '<!--line.number.red-->', '<!--source.code.red-->');
highlightLines([<!--green.lines-->], '<!--line.number.green-->', '<!--source.code.green-->');
something else
'@
            $template = $template.Replace("`r`n", "`n")
            $expected = @'
something
highlightLines([1], '<!--line.number.yellow-->', '<!--source.code.yellow-->');
highlightLines([3], '<!--line.number.red-->', '<!--source.code.red-->');
highlightLines([2], '<!--line.number.green-->', '<!--source.code.green-->');
something else
'@
            $expected = $expected.Replace("`r`n", "`n")

            $sourceFile = [PSCustomObject]@{
                'line' = [PSCustomObject[]]@(
                # yellow
                    [PSCustomObject]@{
                        '@nr' = '1';
                        '@mi' = '6';
                        '@ci' = '3';
                        '@mb' = '0';
                        '@cb' = '0';
                    },
                    # green
                    [PSCustomObject]@{
                        '@nr' = '2';
                        '@mi' = '0';
                        '@ci' = '3';
                        '@mb' = '0';
                        '@cb' = '0';
                    },
                    # red
                    [PSCustomObject]@{
                        '@nr' = '3';
                        '@mi' = '6';
                        '@ci' = '0';
                        '@mb' = '0';
                        '@cb' = '0';
                    }
                )
            }

            $result = Render-CoverageLineColors -template $template -sourcefile $sourceFile
            $result | Should -Be $expected
        }
    }
}