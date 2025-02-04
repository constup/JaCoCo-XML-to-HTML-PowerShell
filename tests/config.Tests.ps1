Describe 'Verify-Config' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\src\config.ps1").Path
    }

    It 'Should pass all verifications.' {
        $jacocoxml2htmlConfig = [PSCustomObject]@{
            'xml_file' = 'lorem ipsum';
            'destination_directory' = 'lorem ipsum';
            'sources_directory' = 'lorem ipsum';
            'theme' = 'dark';
        }
        $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

        Verify-Config
    }

    Context 'XML file property is invalid.' {
        It 'Should throw an error when XML file property is not set in configuration.' {
            $jacocoxml2htmlConfig = [PSCustomObject]@{
                'destination_directory' = 'lorem ipsum';
                'sources_directory' = 'lorem ipsum';
                'theme' = 'dark';
            }
            $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

            { Verify-Config } | Should -Throw -ExpectedMessage "'xml_file' configuration property is missing."
        }

        It 'Should throw an error when XML file property exists in configuration, but it is empty.' {
            $jacocoxml2htmlConfig = [PSCustomObject]@{
                'xml_file' = '';
                'destination_directory' = 'lorem ipsum';
                'sources_directory' = 'lorem ipsum';
                'theme' = 'dark';
            }
            $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

            { Verify-Config } | Should -Throw -ExpectedMessage "'xml_file' configuration property is missing."
        }
    }

    Context 'destination_directory property is invalid.' {
        It 'Should throw an error when destination directory property is not set in configuration.' {
            $jacocoxml2htmlConfig = [PSCustomObject]@{
                'xml_file' = 'lorem ipsum'
                'sources_directory' = 'lorem ipsum';
                'theme' = 'dark';
            }
            $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

            { Verify-Config } | Should -Throw -ExpectedMessage "'destination_directory' configuration property is missing."
        }

        It 'Should throw an error when destination directory property exists in configuration, but it is empty.' {
            $jacocoxml2htmlConfig = [PSCustomObject]@{
                'xml_file' = 'lorem ipsum';
                'destination_directory' = '';
                'sources_directory' = 'lorem ipsum';
                'theme' = 'dark';
            }
            $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

            { Verify-Config } | Should -Throw -ExpectedMessage "'destination_directory' configuration property is missing."
        }
    }

    Context 'sources_directory property is invalid.' {
        It 'Should throw an error when sources directory property is not set in configuration.' {
            $jacocoxml2htmlConfig = [PSCustomObject]@{
                'xml_file' = 'lorem ipsum'
                'destination_directory' = 'lorem ipsum';
                'theme' = 'dark';
            }
            $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

            { Verify-Config } | Should -Throw -ExpectedMessage "'sources_directory' configuration property is missing."
        }

        It 'Should throw an error when sources directory property exists in configuration, but it is empty.' {
            $jacocoxml2htmlConfig = [PSCustomObject]@{
                'xml_file' = 'lorem ipsum';
                'destination_directory' = 'lorem ipsum';
                'sources_directory' = '';
                'theme' = 'dark';
            }
            $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

            { Verify-Config } | Should -Throw -ExpectedMessage "'sources_directory' configuration property is missing."
        }
    }

    Context 'theme property is invalid.' {
        It 'Should throw an error when theme property is not set in configuration.' {
            $jacocoxml2htmlConfig = [PSCustomObject]@{
                'xml_file' = 'lorem ipsum'
                'destination_directory' = 'lorem ipsum';
                'sources_directory' = 'lorem ipsum';
            }
            $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

            { Verify-Config } | Should -Throw -ExpectedMessage "'theme' configuration property is missing or invalid. Valid values for 'theme': 'light', 'dark'."
        }

        It 'Should throw an error when theme property exists in configuration, but it is empty.' {
            $jacocoxml2htmlConfig = [PSCustomObject]@{
                'xml_file' = 'lorem ipsum';
                'destination_directory' = 'lorem ipsum';
                'sources_directory' = 'lorem ipsum';
                'theme' = '';
            }
            $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

            { Verify-Config } | Should -Throw -ExpectedMessage "'theme' configuration property is missing or invalid. Valid values for 'theme': 'light', 'dark'."
        }

        It 'Should throw an error when theme property exists in configuration, but its value is invalid.' {
            $jacocoxml2htmlConfig = [PSCustomObject]@{
                'xml_file' = 'lorem ipsum';
                'destination_directory' = 'lorem ipsum';
                'sources_directory' = 'lorem ipsum';
                'theme' = 'green';
            }
            $Global:jacocoxml2htmlConfig = $jacocoxml2htmlConfig

            { Verify-Config } | Should -Throw -ExpectedMessage "'theme' configuration property is missing or invalid. Valid values for 'theme': 'light', 'dark'."
        }
    }
}

Describe 'Load-Config' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\src\config.ps1").Path
    }

    Context 'Config is properly loaded and verified' {
        BeforeAll {
            Set-Content -Path "TestDrive:\config.ps1" -Value @'
$Global:jacocoxml2htmlConfig = [PSCustomObject]@{
    'xml_file' = "TestDrive:\coverage.xml";
    'destination_directory' = "TestDrive:\coverage\html";
    'sources_directory' = "TestDrive:\src";
}
'@
            Set-Content -Path "TestDrive:\default-config.ps1" -Value @'
$Global:jacocoxml2htmlConfig = [PSCustomObject]@{
    # light theme
    'source_code_theme_light' = 'vs.min.css';
    'line_number_yellow_light' = '#ffffc8';
    'line_number_red_light' = '#ffc8c8';
    'line_number_green_light' = '#c8ffc8';
    'source_code_yellow_light' = '#fffff0';
    'source_code_red_light' = '#fff0f0';
    'source_code_green_light' = '#f0fff0';
    # dark theme
    'source_code_theme_dark' = 'vs2015.min.css';
    'line_number_yellow_dark' = '#ffffc840';
    'line_number_red_dark' = '#ffc8c840';
    'line_number_green_dark' = '#c8ffc840';
    'source_code_yellow_dark' = '#ffff8c20';
    'source_code_red_dark' = '#ff8c8c20';
    'source_code_green_dark' = '#8cff8c20';
    'theme' = 'light';
}
'@
            Mock -CommandName Resolve-Path -MockWith {
                param($Path)

                switch -Wildcard ($path) {
                    "*../default-config.ps1" { return [PSCustomObject]@{ "Path" = "TestDrive:\default-config.ps1" } }
                    Default { return [PSCustomObject]@{ "Path" = $Path } }
                }
            }
        }

        It 'Should properly load and verify configuration' {
            Test-Path -Path "TestDrive:\config.ps1" | Should -Be $true
            Test-Path -Path "TestDrive:\default-config.ps1" | Should -Be $true

            Load-Config -configFileLocation "TestDrive:\config.ps1"

            $Global:jacocoxml2htmlConfig.xml_file | Should -Be "TestDrive:\coverage.xml"
            $Global:jacocoxml2htmlConfig.destination_directory | Should -Be "TestDrive:\coverage\html"
            $Global:jacocoxml2htmlConfig.sources_directory | Should -Be "TestDrive:\src"
        }
    }

    Context 'Config is not properly loaded' {
        It 'Should throw an error when default config can not be loaded' {
            Mock -CommandName Resolve-Path -MockWith {
                param($Path)

                switch -Wildcard ($path) {
                    "*../default-config.ps1" { return [PSCustomObject]@{ "Path" = "TestDrive:\non-existing-default-config.ps1" } }
                    Default { return [PSCustomObject]@{ "Path" = $Path } }
                }
            }
            Test-Path -Path "TestDrive:\default-config.ps1" | Should -Be $false
            Set-Content -Path TestDrive:\config.ps1 -Value @'
$Global:jacocoxml2htmlConfig = [PSCustomObject]@{
    'xml_file' = "TestDrive:\coverage.xml";
    'destination_directory' = "TestDrive:\coverage\html";
    'sources_directory' = "TestDrive:\src";
}
'@
            { Load-Config -configFileLocation 'TestDrive:\config.ps1' } | Should -Throw -ExpectedMessage "Default config failed to load."
            Remove-Item "TestDrive:\config.ps1"
        }

        It 'Should throw an error when config file can not be loaded' {
            Mock -CommandName Resolve-Path -MockWith {
                param($Path)

                switch -Wildcard ($path) {
                    "*../default-config.ps1" { return [PSCustomObject]@{ "Path" = "TestDrive:\default-config.ps1" } }
                    Default { return $Path }
                }
            }
            Test-Path -Path "TestDrive:\config.ps1" | Should -Be $false
            Set-Content -Path "TestDrive:\default-config.ps1" -Value @'
$Global:jacocoxml2htmlConfig = [PSCustomObject]@{
    # light theme
    'source_code_theme_light' = 'vs.min.css';
    'line_number_yellow_light' = '#ffffc8';
    'line_number_red_light' = '#ffc8c8';
    'line_number_green_light' = '#c8ffc8';
    'source_code_yellow_light' = '#fffff0';
    'source_code_red_light' = '#fff0f0';
    'source_code_green_light' = '#f0fff0';
    # dark theme
    'source_code_theme_dark' = 'vs2015.min.css';
    'line_number_yellow_dark' = '#ffffc840';
    'line_number_red_dark' = '#ffc8c840';
    'line_number_green_dark' = '#c8ffc840';
    'source_code_yellow_dark' = '#ffff8c20';
    'source_code_red_dark' = '#ff8c8c20';
    'source_code_green_dark' = '#8cff8c20';
    'theme' = 'light';
}
'@
            { Load-Config -configFileLocation 'TestDrive:\config.ps1' } | Should -Throw -ExpectedMessage "Configuration file failed to laod."
        }
    }
}