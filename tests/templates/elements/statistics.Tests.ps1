Describe 'Render-StatisticsRow' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\statistics.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\utilities\string.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\assets.ps1").Path
    }

    It 'Should render statistics row with data. Directory depth 3' {
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
something
'@
        $template = $template.Replace("`r`n", "`n")
        $expected = @'
packages/directory\sample.html
directory\sample
2
4
1 - 66 - 67 - 98.51%

1 - 53 - 54 - 98.15%
0 - 5 - 5 - 100.00%
0 - 3 - 3 - 100.00%

something
'@
        $expected = $expected.Replace("`r`n", "`n")
        $object = [PSCustomObject]@{
            "@name" = "directory\sample";
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

        $result = Render-StatisticsRow -template $template -object $object -directoryDepth $directoryDepth
        $result | Should -Be $expected
    }
}

Describe 'Render-StatisticsCard' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\statistics.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\utilities\string.ps1").Path
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\assets.ps1").Path
    }

    It 'Should render card with two rows' {
        $cardTemplate = @'
<!--page.theme-->
<!--statistics rows-->
<!--statistics card title-->
'@
        $Global:jacocoxml2htmlConfig = [PSCustomObject]@{'theme' = 'dark';}
        $cardTemplate = $cardTemplate.Replace("`r`n", "`n")
        $rowTemplate = @'
sample row template
'@
        $rowTemplate = $rowTemplate.Replace("`r`n", "`n")
        $objects = [PSCustomObject[]]@(
            [PSCustomObject]@{
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
            },
            [PSCustomObject]@{
                "@name" = "directory\another_sample.ps1";
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
                        "@missed" = "15";
                        "@covered" = "66";
                    },
                    [PSCustomObject]@{
                        "@type" = "LINE";
                        "@missed" = "12";
                        "@covered" = "53";
                    },
                    [PSCustomObject]@{
                        "@type" = "METHOD";
                        "@missed" = "3";
                        "@covered" = "5";
                    },
                    [PSCustomObject]@{
                        "@type" = "CLASS";
                        "@missed" = "0";
                        "@covered" = "3";
                    }
                );
            }
        )
        $cardTitle = 'lorem ipsum'
        $directoryDepth = 2
        $expected = @'
dark
sample row template
sample row template
lorem ipsum
'@
        $expected = $expected.Replace("`r`n", "`n")

        $result = Render-StatisticsCard `
            -cardTemplate $cardTemplate `
            -rowTemplate $rowTemplate `
            -objects $objects `
            -cardTitle $cardTitle `
            -directoryDepth $directoryDepth
        $result | Should -Be $expected
    }
}