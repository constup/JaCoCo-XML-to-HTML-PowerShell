Describe 'Render-CustomCSS' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\templates\elements\custom-css.ps1").Path
    }

    It 'Should render custom css for a group page. 0 directory depth.' {
        $template = @'
<!--something-->
<!--custom.css-->
<!--something.else-->
'@
        $expected = @'
<!--something-->
    <link rel="stylesheet" type="text/css" href="css/group_page_custom.css" />
<!--something.else-->
'@
        $directoryDepth = 0
        $pageType = 'group'

        $result = Render-CustomCss -template $template -directoryDepth $directoryDepth -pageType $pageType
        $result | Should -Be $expected
    }

    It 'Should render custom css for a group page. Non 0 directory depth.' {
        $template = @'
<!--something-->
<!--custom.css-->
<!--something.else-->
'@
        $expected = @'
<!--something-->
    <link rel="stylesheet" type="text/css" href="../../../css/group_page_custom.css" />
<!--something.else-->
'@
        $directoryDepth = 3
        $pageType = 'group'

        $result = Render-CustomCss -template $template -directoryDepth $directoryDepth -pageType $pageType
        $result | Should -Be $expected
    }

    It 'Should render custom css for a source page. Non 0 directory depth.' {
        $template = @'
<!--something-->
<!--custom.css-->
<!--something.else-->
'@
        $expected = @'
<!--something-->
    <link rel="stylesheet" type="text/css" href="../../../css/source_page_custom.css" />
<!--something.else-->
'@
        $directoryDepth = 3
        $pageType = 'source'

        $result = Render-CustomCss -template $template -directoryDepth $directoryDepth -pageType $pageType
        $result | Should -Be $expected
    }
}