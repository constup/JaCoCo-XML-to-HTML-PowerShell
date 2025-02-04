Describe 'Render-CounterRowData' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\counter.ps1").Path
    }

    Context 'There is no 100% instructions coverage' {
        It 'Should render a coverage counter row with data.' {
            $template = @'
<!--100.percent-->
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
            $counters = @(
                [PSCustomObject]@{
                    '@type' = 'INSTRUCTION'
                    '@missed' = '153'
                    '@covered' = '108'
                }
                [PSCustomObject]@{
                    '@type' = 'LINE'
                    '@missed' = '130'
                    '@covered' = '82'
                }
                [PSCustomObject]@{
                    '@type' = 'METHOD'
                    '@missed' = '5'
                    '@covered' = '12'
                }
                [PSCustomObject]@{
                    '@type' = 'CLASS'
                    '@missed' = '3'
                    '@covered' = '5'
                }
            )
            $counterType = 'INSTRUCTION'
            $placeholder = '<!--counter.instructions-->'
            $expected = @'

<!--page.location-->
<!--item.name-->
<!--classes.count-->
<!--sourcefiles.count-->
153 - 108 - 261 - 41.38%
<!--counter.branches-->
<!--counter.lines-->
<!--counter.methods-->
<!--counter.classes-->
<!--counter.complexity-->
'@

            $result = Render-CounterRowData -template $template -counters $counters -counterType $counterType -placeholder $placeholder
            $result | Should -Be $expected
        }

        It 'Should render a coverage counter row without data.' {
            $template = @'
<!--100.percent-->
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
<!--page.location-->
'@
            $counters = @(
                [PSCustomObject]@{
                    '@type' = 'INSTRUCTION'
                    '@missed' = '153'
                    '@covered' = '108'
                }
                [PSCustomObject]@{
                    '@type' = 'LINE'
                    '@missed' = '130'
                    '@covered' = '82'
                }
                [PSCustomObject]@{
                    '@type' = 'METHOD'
                    '@missed' = '5'
                    '@covered' = '12'
                }
                [PSCustomObject]@{
                    '@type' = 'CLASS'
                    '@missed' = '3'
                    '@covered' = '5'
                }
            )
            $counterType = 'COMPLEXITY'
            $placeholder = '<!--counter.complexity-->'
            $expected = @'
<!--100.percent-->
<!--page.location-->
<!--item.name-->
<!--classes.count-->
<!--sourcefiles.count-->
<!--counter.instructions-->
<!--counter.branches-->
<!--counter.lines-->
<!--counter.methods-->
<!--counter.classes-->

<!--page.location-->
'@
            $result = Render-CounterRowData -template $template -counters $counters -counterType $counterType -placeholder $placeholder
            $result | Should -Be $expected
        }
    }

    Context 'There is 100% instructions coverage.' {
        It 'Should render a coverage counter row with data. Light theme.' {
            $Global:jacocoxml2htmlConfig = [PSCustomObject]@{
                'theme' = 'light';
                'source_code_green_light' = '#c8ffc8';
            }
                $template = @'
<!--100.percent-->
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
            $counters = @(
                [PSCustomObject]@{
                    '@type' = 'INSTRUCTION'
                    '@missed' = '0'
                    '@covered' = '108'
                }
                [PSCustomObject]@{
                    '@type' = 'LINE'
                    '@missed' = '130'
                    '@covered' = '82'
                }
                [PSCustomObject]@{
                    '@type' = 'METHOD'
                    '@missed' = '5'
                    '@covered' = '12'
                }
                [PSCustomObject]@{
                    '@type' = 'CLASS'
                    '@missed' = '3'
                    '@covered' = '5'
                }
            )
            $counterType = 'INSTRUCTION'
            $placeholder = '<!--counter.instructions-->'
            $expected = @'
style="background-color: #c8ffc8;"
<!--page.location-->
<!--item.name-->
<!--classes.count-->
<!--sourcefiles.count-->
0 - 108 - 108 - 100.00%
<!--counter.branches-->
<!--counter.lines-->
<!--counter.methods-->
<!--counter.classes-->
<!--counter.complexity-->
'@
            $result = Render-CounterRowData -template $template -counters $counters -counterType $counterType -placeholder $placeholder
            $result | Should -Be $expected
        }

        It 'Should render a coverage counter row with data. Dark theme.' {
            $Global:jacocoxml2htmlConfig = [PSCustomObject]@{
                'theme' = 'dark';
                'source_code_green_dark' = '#ffffc8';
            }
            $template = @'
<!--100.percent-->
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
            $counters = @(
                [PSCustomObject]@{
                    '@type' = 'INSTRUCTION'
                    '@missed' = '0'
                    '@covered' = '108'
                }
                [PSCustomObject]@{
                    '@type' = 'LINE'
                    '@missed' = '130'
                    '@covered' = '82'
                }
                [PSCustomObject]@{
                    '@type' = 'METHOD'
                    '@missed' = '5'
                    '@covered' = '12'
                }
                [PSCustomObject]@{
                    '@type' = 'CLASS'
                    '@missed' = '3'
                    '@covered' = '5'
                }
            )
            $counterType = 'INSTRUCTION'
            $placeholder = '<!--counter.instructions-->'
            $expected = @'
style="background-color: #ffffc8;"
<!--page.location-->
<!--item.name-->
<!--classes.count-->
<!--sourcefiles.count-->
0 - 108 - 108 - 100.00%
<!--counter.branches-->
<!--counter.lines-->
<!--counter.methods-->
<!--counter.classes-->
<!--counter.complexity-->
'@
            $result = Render-CounterRowData -template $template -counters $counters -counterType $counterType -placeholder $placeholder
            $result | Should -Be $expected
        }
    }
}