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
../../../sources/directory\sample.ps1.html
sample.ps1
1 - 66 - 67 - 98.51%

1 - 53 - 54 - 98.15%
0 - 5 - 5 - 100.00%
0 - 3 - 3 - 100.00%

something
'@
        $expected = $expected.Replace("`r`n", "`n")
        $object = [PSCustomObject]@{
            "@name" = "directory\sample.ps1";
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

Describe 'Render-SourcefilesCard' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\sourcefiles.ps1").Path
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

        $result = Render-SourcefilesCard `
            -cardTemplate $cardTemplate `
            -rowTemplate $rowTemplate `
            -objects $objects `
            -cardTitle $cardTitle `
            -directoryDepth $directoryDepth
        $result | Should -Be $expected
    }
}