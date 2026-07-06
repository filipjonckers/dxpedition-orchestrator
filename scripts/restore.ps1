. "C:\dxpedition-orchestrator\scripts\helpers.ps1"

$scriptDir = "C:\dxpedition-orchestrator\scripts"

Write-Log "Restore started"
Write-Log "Restore will reapply configuration, reinstall missing software, and restore files"

function Invoke-RestorePhase {
    param([string]$Name, [string]$Script)

    $scriptPath = "$scriptDir\$Script"
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
    }
}

Write-Log "=== Restore: Windows Configuration ==="
Invoke-RestorePhase -Name "Windows Configuration" -Script "configure-windows.ps1"

Write-Log "=== Restore: Software Installation ==="
Invoke-RestorePhase -Name "Software Installation" -Script "install-software.ps1"

Write-Log "=== Restore: File Copy ==="
Invoke-RestorePhase -Name "File Copy" -Script "copy-files.ps1"

Write-Log "Restore completed successfully"