function Preload-Templates {
    $result = [PSCustomObject]@{}

    $templates = @(
        "index.html",
        "source.html",
        "elements\main-coverage-card.html",
        "elements\statistics-card-row.html",
        "elements\sourcefile-card-row.html",
        "elements\statistics-card.html",
        "elements\sourcefiles-card.html"
    )

    foreach ($templatePath in $templates) {
        $fullPath = (Resolve-Path "$PSScriptRoot\..\..\assets\templates\$templatePath").Path
        $templateContent = Get-Content -Raw -Path $fullPath
        $normalizedContent = $templateContent.Replace("`r`n", "`n")
        $key = $templatePath -replace '\.html$', ''
        $result | Add-Member -MemberType NoteProperty -Name $key -Value $normalizedContent
    }

    return $result
}