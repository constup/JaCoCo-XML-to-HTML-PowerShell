enum PageType {
    group
    source
}

function Render-CustomCSS {
    param(
        [Parameter(Mandatory=$true)]
        [String]$template,
        [Parameter(Mandatory=$true)]
        [int]$directoryDepth,
        [Parameter(Mandatory=$true)]
        [PageType]$pageType
    )

    . (Resolve-Path "$PSScriptRoot\..\..\assets.ps1").Path

    if ($pageType -eq 'group') {
        $href = 'css/group_page_custom.css'
    } else {
        $href = 'css/source_page_custom.css'
    }
    $result = $template.Replace('<!--custom.css-->', "    <link rel=`"stylesheet`" type=`"text/css`" href=`"$href`" />")
    $result = Render-AssetPath -template $result -asset "$href" -directoryDepth $directoryDepth

    return $result
}