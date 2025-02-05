Describe 'Render-SourcefileRow' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\sourcefiles.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\utilities\string.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\assets.ps1").Path
    }

    It 'Should render sourcefile row with data. Directory depth 3' {
        $template = @'
<!--page.location-->
<!--item.name-->
<!--classes.count-->
<!--sourcefiles.count-->
<!--counter.instructions-->
<!--counter.branches-->
<!--counter.lines-->
<!--counter.methods-->
<!--counter.classes-->
<!--counter.complexity-->
'@
        $template = $template.Replace("`r`n", "`n")
        $expected = @'
../../../sources/directory\sample.ps1.html
sample.ps1
2
4
1 - 66 - 67 - 98.51%

1 - 53 - 54 - 98.15%
0 - 5 - 5 - 100.00%
0 - 3 - 3 - 100.00%

'@
        $expected = $expected.Replace("`r`n", "`n")
        $object = [PSCustomObject]@{
            "@name" = "directory\sample.ps1";
            "class" = [PSCustomObject[]]@(
                [PSCustomObject]@{
                    "something" = "lorem ipsum";
                },
                [PSCustomObject]@{
                    "something_else" = "lorem ipsum dolor";
                }
            );
            "sourcefile" = [PSCustomObject[]]@(
                [PSCustomObject]@{
                    "something" = "lorem ipsum";
                },
                [PSCustomObject]@{
                    "something_else" = "lorem ipsum dolor";
                },
                [PSCustomObject]@{
                    "something" = "lorem ipsum";
                },
                [PSCustomObject]@{
                    "something_else" = "lorem ipsum dolor";
                }
            );
            "counter" = [PSCustomObject[]]@(
                [PSCustomObject]@{
                    "@type" = "INSTRUCTION";
                    "@missed" = "1";
                    "@covered" = "66";
                },
                [PSCustomObject]@{
                    "@type" = "LINE";
                    "@missed" = "1";
                    "@covered" = "53";
                },
                [PSCustomObject]@{
                    "@type" = "METHOD";
                    "@missed" = "0";
                    "@covered" = "5";
                },
                [PSCustomObject]@{
                    "@type" = "CLASS";
                    "@missed" = "0";
                    "@covered" = "3";
                }
            );
        }
        $directoryDepth = 3

        $result = Render-SourcefileRow -template $template -object $object -directoryDepth $directoryDepth
        $result | Should -Be $expected
    }
}