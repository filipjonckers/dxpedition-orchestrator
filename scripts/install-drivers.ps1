. "C:\dxpedition-orchestrator\scripts\helpers.ps1"

Write-Log "Driver installation phase started"

$config = Read-Yaml -Path "C:\dxpedition-orchestrator\config\system.yml"
$driverMode = if ($config.ContainsKey("driver_mode")) { $config["driver_mode"] } else { "windows_update" }

Write-Log "Driver mode: $driverMode"

Write-Log "Driver installation — not yet implemented" "WARN"
Write-Log "Future tasks: Windows Update drivers, local driver packages, skip if unavailable"

Write-Log "Driver installation phase completed"