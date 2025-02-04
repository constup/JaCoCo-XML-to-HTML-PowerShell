Describe 'Copy-Assets' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\src\assets.ps1").Path
    }

    Context 'No custom CSS' {
        It 'Should copy all assets' {
            Mock -CommandName Resolve-Path -MockWith {
                param($Path)

                switch -Wildcard ($Path)
                {
                    "*bootstrap.min.css" {
                        return [PSCustomObject]@{ "Path" = "TestDrive:\sample\assets\bootstrap\css\sample.css" }
                    }
                    "*assets\highlightjs" {
                        return [PSCustomObject]@{ "Path" = "TestDrive:\sample\highlightjs" }
                    }
                    "*assets\highlightjs-line-numbers" {
                        return [PSCustomObject]@{ "Path" = "TestDrive:\sample\highlightjs-line-numbers" }
                    }
                    Default {
                        return [PSCusomObject]@{ "Path" = $Path }
                    }
                }
            }

            New-Item -ItemType Directory -Force -Path "TestDrive:\sample\assets\bootstrap\css"
            Set-Content -Path "TestDrive:\sample\assets\bootstrap\css\sample.css" -Value 'lorem ipsum'
            New-Item -ItemType Directory -Force -Path "TestDrive:\sample\highlightjs"
            Set-Content -Path "TestDrive:\sample\highlightjs\somefile.txt" -Value "sample"
            New-Item -ItemType Directory -Force -Path "TestDrive:\sample\highlightjs-line-numbers"
            Set-Content -Path "TestDrive:\sample\highlightjs-line-numbers\anotherfile.txt" -Value "something"

            Copy-Assets -destinationDirectory "TestDrive:\sample\destination"

            Test-Path -Path 'TestDrive:\sample\destination\css' | Should -Be $true
            Test-Path -Path 'TestDrive:\sample\destination\css\bootstrap.min.css' | Should -Be $true
            Get-Content -Raw 'TestDrive:\sample\destination\css\bootstrap.min.css' | Should -Be (Get-Content -Raw 'TestDrive:\sample\assets\bootstrap\css\sample.css')
            Test-Path -Path 'TestDrive:\sample\destination\highlightjs' | Should -Be $true
            Test-Path -Path 'TestDrive:\sample\destination\highlightjs\somefile.txt' | Should -Be $true
            Get-Content -Raw 'TestDrive:\sample\destination\highlightjs\somefile.txt' | Should -Be (Get-Content -Raw 'TestDrive:\sample\highlightjs\somefile.txt')
            Test-Path -Path 'TestDrive:\sample\destination\highlightjs-line-numbers' | Should -Be $true
            Test-Path -Path 'TestDrive:\sample\destination\highlightjs-line-numbers\anotherfile.txt' | Should -Be $true
            Get-Content -Raw 'TestDrive:\sample\destination\highlightjs-line-numbers\anotherfile.txt' | Should -Be (Get-Content -Raw 'TestDrive:\sample\highlightjs-line-numbers\anotherfile.txt')
        }
    }

    Context 'With custom CSS' {
        BeforeAll {
            $Global:jacocoxml2htmlConfig = [PSCustomObject]@{
                'group_page_custom_css' = 'TestDrive:\your\group.css';
                'source_page_custom_css' = 'TestDrive:\your\source.css';
            }
        }

        It 'Should copy all assets' {
            Mock -CommandName Resolve-Path -MockWith {
                param($Path)

                switch -Wildcard ($Path)
                {
                    "*bootstrap.min.css" {
                        return [PSCustomObject]@{ "Path" = "TestDrive:\sample\assets\bootstrap\css\sample.css" }
                    }
                    "*assets\highlightjs" {
                        return [PSCustomObject]@{ "Path" = "TestDrive:\sample\highlightjs" }
                    }
                    "*assets\highlightjs-line-numbers" {
                        return [PSCustomObject]@{ "Path" = "TestDrive:\sample\highlightjs-line-numbers" }
                    }
                    Default {
                        return [PSCustomObject]@{ "Path" = $Path }
                    }
                }
            }

            New-Item -ItemType Directory -Force -Path "TestDrive:\your"
            Set-Content -Path "TestDrive:\your\group.css" -Value "sample group page css file"
            Set-Content -Path "TestDrive:\your\source.css" -Value "sample source page css file"

            New-Item -ItemType Directory -Force -Path "TestDrive:\sample\assets\bootstrap\css"
            Set-Content -Path "TestDrive:\sample\assets\bootstrap\css\sample.css" -Value 'lorem ipsum'
            New-Item -ItemType Directory -Force -Path "TestDrive:\sample\highlightjs"
            Set-Content -Path "TestDrive:\sample\highlightjs\somefile.txt" -Value "sample"
            New-Item -ItemType Directory -Force -Path "TestDrive:\sample\highlightjs-line-numbers"
            Set-Content -Path "TestDrive:\sample\highlightjs-line-numbers\anotherfile.txt" -Value "something"

            Copy-Assets -destinationDirectory "TestDrive:\sample\destination"

            Test-Path -Path 'TestDrive:\sample\destination\css' | Should -Be $true
            Test-Path -Path 'TestDrive:\sample\destination\css\bootstrap.min.css' | Should -Be $true
            Get-Content -Raw 'TestDrive:\sample\destination\css\bootstrap.min.css' | Should -Be (Get-Content -Raw 'TestDrive:\sample\assets\bootstrap\css\sample.css')
            Test-Path -Path 'TestDrive:\sample\destination\css\group_page_custom.css' | Should -Be $true
            Test-Path -Path 'TestDrive:\sample\destination\css\source_page_custom.css' | Should -Be $true
            Get-Content -Raw 'TestDrive:\sample\destination\css\group_page_custom.css' | Should -Be (Get-Content -Raw 'TestDrive:\your\group.css')
            Get-Content -Raw 'TestDrive:\sample\destination\css\source_page_custom.css' | Should -Be (Get-Content -Raw 'TestDrive:\your\source.css')
            Test-Path -Path 'TestDrive:\sample\destination\highlightjs' | Should -Be $true
            Test-Path -Path 'TestDrive:\sample\destination\highlightjs\somefile.txt' | Should -Be $true
            Get-Content -Raw 'TestDrive:\sample\destination\highlightjs\somefile.txt' | Should -Be (Get-Content -Raw 'TestDrive:\sample\highlightjs\somefile.txt')
            Test-Path -Path 'TestDrive:\sample\destination\highlightjs-line-numbers' | Should -Be $true
            Test-Path -Path 'TestDrive:\sample\destination\highlightjs-line-numbers\anotherfile.txt' | Should -Be $true
            Get-Content -Raw 'TestDrive:\sample\destination\highlightjs-line-numbers\anotherfile.txt' | Should -Be (Get-Content -Raw 'TestDrive:\sample\highlightjs-line-numbers\anotherfile.txt')
        }
    }
}

Describe 'Render-AssetPath' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\src\assets.ps1").Path
    }

    It 'Should render asset when dircetory depth is 0.' {
        $template = @'
This is the first line.
This line contains a template: something.css.
This is the last line.
'@
        $expected = @'
This is the first line.
This line contains a template: something.css.
This is the last line.
'@
        $asset = 'something.css'
        $directoryDepth = 0

        $result = Render-AssetPath -template $template -asset $asset -directoryDepth $directoryDepth
        $result | Should -Be $expected
    }

    It 'Should render asset when dircetory depth is 1.' {
        $template = @'
This is the first line.
This line contains a template: something.css.
This is the last line.
'@
        $expected = @'
This is the first line.
This line contains a template: ../something.css.
This is the last line.
'@
        $asset = 'something.css'
        $directoryDepth = 1

        $result = Render-AssetPath -template $template -asset $asset -directoryDepth $directoryDepth
        $result | Should -Be $expected
    }

    It 'Should render asset when dircetory depth is 4.' {
        $template = @'
This is the first line.
This line contains a template: something.css.
This is the last line.
'@
        $expected = @'
This is the first line.
This line contains a template: ../../../../something.css.
This is the last line.
'@
        $asset = 'something.css'
        $directoryDepth = 4

        $result = Render-AssetPath -template $template -asset $asset -directoryDepth $directoryDepth
        $result | Should -Be $expected
    }

}