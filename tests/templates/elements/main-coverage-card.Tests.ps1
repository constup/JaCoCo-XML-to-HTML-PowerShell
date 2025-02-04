Describe 'Render-MainCoverageCardCounter' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\main-coverage-card.ps1").Path
        $Global:mainCoveragreCardTestingTemplate = @'
<!--card title-->
<!--report.counter.instructions empty counter cleanup placeholder-->
<!--report.counter.instructions.missed-->
<!--report.counter.instructions.covered-->
<!--report.counter.instructions.total-->
<!--report.counter.instructions.percent-->
<!--report.counter.instructions.percent-->
<!--report.counter.branches empty counter cleanup placeholder-->
<!--report.counter.branches.missed-->
<!--report.counter.branches.covered-->
<!--report.counter.branches.total-->
<!--report.counter.branches.percent-->
<!--report.counter.branches.percent-->
<!--report.counter.lines empty counter cleanup placeholder-->
<!--report.counter.lines.missed-->
<!--report.counter.lines.covered-->
<!--report.counter.lines.total-->
<!--report.counter.lines.percent-->
<!--report.counter.lines.percent-->
<!--report.counter.methods empty counter cleanup placeholder-->
<!--report.counter.methods.missed-->
<!--report.counter.methods.covered-->
<!--report.counter.methods.total-->
<!--report.counter.methods.percent-->
<!--report.counter.methods.percent-->
<!--report.counter.classes empty counter cleanup placeholder-->
<!--report.counter.classes.missed-->
<!--report.counter.classes.covered-->
<!--report.counter.classes.total-->
<!--report.counter.classes.percent-->
<!--report.counter.classes.percent-->
<!--report.counter.complexity empty counter cleanup placeholder-->
<!--report.counter.complexity.missed-->
<!--report.counter.complexity.covered-->
<!--report.counter.complexity.total-->
<!--report.counter.complexity.percent-->
<!--report.counter.complexity.percent-->
'@
    }

    Context 'There is data to be rendered. The row should be rendered with data.' {
        It 'Should process INSTRUCTION counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
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
            $placeholder = 'report.counter.instructions'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-01.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process BRANCH counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
                [PSCustomObject]@{
                    '@type' = 'BRANCH'
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
            $counterType = 'BRANCH'
            $placeholder = 'report.counter.branches'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-02.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process LINE counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
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
            $counterType = 'LINE'
            $placeholder = 'report.counter.lines'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-03.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process METHOD counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
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
            $counterType = 'METHOD'
            $placeholder = 'report.counter.methods'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-04.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process CLASS counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
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
            $counterType = 'CLASS'
            $placeholder = 'report.counter.classes'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-05.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process COMPLEXITY counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
                [PSCustomObject]@{
                    '@type' = 'COMPLEXITY'
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
            $placeholder = 'report.counter.complexity'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-06.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
    }
    Context 'There is no data to be rendered. The row should not be rendered at all.' {
        It 'Should process INSTRUCTION counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
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
            $placeholder = 'report.counter.instructions'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-01e.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process BRANCH counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
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
            $counterType = 'BRANCH'
            $placeholder = 'report.counter.branches'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-02e.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process LINE counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
                [PSCustomObject]@{
                    '@type' = 'INSTRUCTION'
                    '@missed' = '153'
                    '@covered' = '108'
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
            $counterType = 'LINE'
            $placeholder = 'report.counter.lines'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-03e.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process METHOD counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
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
                    '@type' = 'CLASS'
                    '@missed' = '3'
                    '@covered' = '5'
                }
            )
            $counterType = 'METHOD'
            $placeholder = 'report.counter.methods'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-04e.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process CLASS counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
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
            )
            $counterType = 'CLASS'
            $placeholder = 'report.counter.classes'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-05e.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
        It 'Should process COMPLEXITY counter correctly.' {
            $template = $Global:mainCoveragreCardTestingTemplate
            $template = $template -replace "`r`n", "`n"
            $reportCounters = @(
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
            $placeholder = 'report.counter.complexity'
            $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-06e.html").Path
            $expected = Get-Content -Raw -Path $path
            $expected = $expected -replace "`r`n", "`n"

            $result = Render-MainCoverageCardCounter `
                    -template $template `
                    -reportCounters $reportCounters `
                    -counterType $counterType `
                    -placeholder $placeholder
            $result | Should -Be $expected
        }
    }
}

Describe 'Render-MainCoverageCard' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\main-coverage-card.ps1").Path
    }

    It 'Should render INSTRUCTION, LINE, METHOD and CLASS, but not BRANCH and COMPLEXITY.' {
        $template = $Global:mainCoveragreCardTestingTemplate
        $template = $template -replace "`r`n", "`n"
        $cardTitle = 'Sample Card Title'
        $reportCounters = @(
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
        $path = (Resolve-Path "$PSScriptRoot\expected\main-coverage-card-07.html").Path
        $expected = Get-Content -Raw -Path $path
        $expected = $expected -replace "`r`n", "`n"

        $result = Render-MainCoverageCard `
                    -template $template `
                    -cardTitle $cardTitle `
                    -reportCounters $reportCounters
        $result | Should -Be $expected
    }
}