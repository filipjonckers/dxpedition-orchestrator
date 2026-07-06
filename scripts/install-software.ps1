. "C:\dxpedition-orchestrator\scripts\helpers.ps1"

Write-Log "Software installation phase started"

$configPath = "C:\dxpedition-orchestrator\config\software.yml"
$config = Read-Yaml -Path $configPath
$softwareDir = "C:\dxpedition-orchestrator\software"

$softwareList = if ($config.ContainsKey("software")) { $config["software"] } else { @() }

if ($softwareList.Count -eq 0) {
    Write-Log "No software selected in configuration"
    Write-Log "Software installation phase completed"
    return
}

Write-Log "Software to install: $($softwareList -join ', ')"
Write-Log "Software directory: $softwareDir"

function Install-SoftwarePackage {
    param([string]$PackageName)

    $packageDir = "$softwareDir\$PackageName"
    $yamlPath = "$packageDir\install.yaml"

    if (-not (Test-Path $yamlPath)) {
        Write-Log "Package '$PackageName' — install.yaml not found at $yamlPath" "ERROR"
        return $false
    }

    $packageConfig = Read-Yaml -Path $yamlPath

    $displayName = if ($packageConfig.ContainsKey("name")) { $packageConfig["name"] } else { $PackageName }
    $installerName = if ($packageConfig.ContainsKey("installer")) { $packageConfig["installer"] } else { "" }
    $arguments = if ($packageConfig.ContainsKey("arguments")) { $packageConfig["arguments"] } else { "" }
    $url = if ($packageConfig.ContainsKey("url")) { $packageConfig["url"] } else { "" }

    $expectedPath = if ($packageConfig.ContainsKey("expected_path")) { $packageConfig["expected_path"] } else { "" }

    if ($expectedPath -ne "" -and (Test-Path $expectedPath)) {
        Write-Log "Package '$displayName' — already installed at $expectedPath, skipping"
        return $true
    }

    $installerPath = "$packageDir\$installerName"

    if (-not (Test-Path $installerPath)) {
        Write-Log "Package '$displayName' — installer not found at $installerPath" "WARN"

        if ($url -ne "") {
            Write-Log "Package '$displayName' — downloading from $url"
            try {
                $downloadedPath = "$packageDir\$installerName"
                Invoke-WebRequest -Uri $url -OutFile $downloadedPath -UseBasicParsing
                $installerPath = $downloadedPath
                Write-Log "Package '$displayName' — download completed"
            } catch {
                Write-Log "Package '$displayName' — download failed: $($_.Exception.Message)" "ERROR"
                return $false
            }
        } else {
            Write-Log "Package '$displayName' — no URL configured and installer not found, skipping" "WARN"
            return $false
        }
    }

    Write-Log "Package '$displayName' — starting installation"
    Write-Log "Package '$displayName' — installer: $installerPath"
    Write-Log "Package '$displayName' — arguments: $arguments"

    try {
        $process = Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait -NoNewWindow -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Log "Package '$displayName' — installation completed (exit code: 0)"
            return $true
        } else {
            Write-Log "Package '$displayName' — installation failed (exit code: $($process.ExitCode))" "ERROR"
            return $false
        }
    } catch {
        Write-Log "Package '$displayName' — installation error: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

$failed = @()

foreach ($packageName in $softwareList) {
    $success = Install-SoftwarePackage -PackageName $packageName
    if (-not $success) {
        $failed += $packageName
    }
}

if ($failed.Count -gt 0) {
    Write-Log "Software installation completed with failures: $($failed -join ', ')" "WARN"
    Write-Log "Failed packages: $($failed -join ', ')"
} else {
    Write-Log "All software packages installed successfully"
}

Write-Log "Software installation phase completed"