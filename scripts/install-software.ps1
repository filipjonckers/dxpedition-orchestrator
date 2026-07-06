. "C:\dxpedition-orchestrator\scripts\helpers.ps1"

Write-Log "Software installation phase started"

$config = Read-Yaml -Path "C:\dxpedition-orchestrator\config\software.yml"

$softwareList = if ($config.ContainsKey("software")) { $config["software"] } else { @() }

if ($softwareList.Count -eq 0) {
    Write-Log "No software selected in configuration"
} else {
    Write-Log "Software to install: $($softwareList -join ', ')"
}

Write-Log "Software installation — not yet implemented" "WARN"
Write-Log "Future tasks: N1MM Logger+, WSJT-X, MSHV, DXLog"

Write-Log "Software installation phase completed"