Describe 'Render-Sessioninfo' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\sessioninfo.ps1").Path

        $Global:template = '<p class="col-md-4 mb-0 text-muted">Session <!--sessioninfo.id-->started at <!--sessioninfo.start--> and ended at <!--sessioninfo.dump-->, lasting for <!--sessioninfo.duration--> seconds.</p>'
    }

    It 'Should render sesssioninfo correctly when milliseconds are used for time.' {
        $expected = '<p class="col-md-4 mb-0 text-muted">Session sample started at 18/01/2025 22:59:12 and ended at 18/01/2025 22:59:13, lasting for 0.867 seconds.</p>'
        $sessioninfoObject = [PSCustomObject]@{
            '@id' = 'sample'
            '@start' = '1737237552398'
            '@dump' = '1737237553265'
        }

        $result = Render-Sessioninfo -template $template -sessioninfoObject $sessioninfoObject
        $result | Should -Be $expected
    }

    It 'Should render sessioninfo correctly when seconds are used for time.' {
        $expected = '<p class="col-md-4 mb-0 text-muted">Session sample started at 18/01/2025 22:59:12 and ended at 18/01/2025 22:59:17, lasting for 5 seconds.</p>'
        $sessioninfoObject = [PSCustomObject]@{
            '@id' = 'sample'
            '@start' = '1737237552'
            '@dump' = '1737237557'
        }

        $result = Render-Sessioninfo -template $template -sessioninfoObject $sessioninfoObject
        $result | Should -Be $expected
    }
}