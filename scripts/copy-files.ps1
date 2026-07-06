. "C:\dxpedition-orchestrator\scripts\helpers.ps1"

Write-Log "File copy phase started"

$config = Read-Yaml -Path "C:\dxpedition-orchestrator\config\files.yml"

$files = if ($config.ContainsKey("files")) { $config["files"] } else { @() }

if ($files.Count -eq 0) {
    Write-Log "No files configured for deployment"
} else {
    Write-Log "Files to deploy: $($files.Count)"
}

Write-Log "File copy — not yet implemented" "WARN"
Write-Log "Future tasks: copy files from files/ to target paths, YAML-based mapping"

Write-Log "File copy phase completed"