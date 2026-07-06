param(
    [string]$ConfigDir = "C:\dxpedition-orchestrator\config",
    [string]$ScriptDir = "C:\dxpedition-orchestrator\scripts"
)

. "$ScriptDir\helpers.ps1"

$Global:LogFile = "C:\dxpedition-orchestrator\logs\deploy.log"

Write-Log "Deployment started"
Write-Log "Loading configuration from $ConfigDir"

$systemConfig = Read-Yaml -Path "$ConfigDir\system.yml"
if ($systemConfig.Count -gt 0) {
    Write-Log "System configuration loaded"
} else {
    Write-Log "No system configuration found, using defaults" "WARN"
}

$softwareConfig = Read-Yaml -Path "$ConfigDir\software.yml"
if ($softwareConfig.Count -gt 0) {
    Write-Log "Software configuration loaded"
} else {
    Write-Log "No software configuration found" "WARN"
}

$filesConfig = Read-Yaml -Path "$ConfigDir\files.yml"
if ($filesConfig.Count -gt 0) {
    Write-Log "File configuration loaded"
} else {
    Write-Log "No file configuration found" "WARN"
}

function Invoke-DeployPhase {
    param(
        [string]$Name,
        [string]$Script,
        [bool]$Critical = $true
    )

    $scriptPath = "$ScriptDir\$Script"

    if (-not (Test-Path $scriptPath)) {
        Write-Log "Phase '$Name' — script not found: $Script" "WARN"
        return
    }

    Write-Log "Phase '$Name' — starting"
    try {
        & $scriptPath
        Write-Log "Phase '$Name' — completed"
    } catch {
        Write-Log "Phase '$Name' — failed: $($_.Exception.Message)" "ERROR"
        if ($Critical) {
            Write-Log "Critical phase failed, stopping deployment" "ERROR"
            exit 1
        }
    }
}

Invoke-DeployPhase -Name "Windows Configuration" -Script "configure-windows.ps1" -Critical $true
Invoke-DeployPhase -Name "Driver Installation" -Script "install-drivers.ps1" -Critical $false
Invoke-DeployPhase -Name "Software Installation" -Script "install-software.ps1" -Critical $true
Invoke-DeployPhase -Name "File Copy" -Script "copy-files.ps1" -Critical $true

Write-Log "Deployment completed successfully"