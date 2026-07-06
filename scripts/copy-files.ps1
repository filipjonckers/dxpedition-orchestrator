. "C:\dxpedition-orchestrator\scripts\helpers.ps1"

Write-Log "File copy phase started"

$filesDir = "C:\dxpedition-orchestrator\files"
$configPath = "C:\dxpedition-orchestrator\config\files.yml"

$config = Read-Yaml -Path $configPath

$fileEntries = if ($config.ContainsKey("files")) { $config["files"] } else { @() }

if ($fileEntries.Count -eq 0) {
    Write-Log "No files configured for deployment"
    Write-Log "File copy phase completed"
    return
}

Write-Log "Files to deploy: $($fileEntries.Count)"

$failed = @()

foreach ($entry in $fileEntries) {
    $entryParts = $entry -split "\|"
    $sourceRelative = $entryParts[0].Trim()
    $destination = $entryParts[1].Trim()

    $sourcePath = "$filesDir\$sourceRelative"

    if (-not (Test-Path $sourcePath)) {
        Write-Log "Source not found: $sourcePath" "WARN"
        $failed += $sourceRelative
        continue
    }

    $destDir = Split-Path $destination -Parent
    if (-not (Test-Path $destDir)) {
        try {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            Write-Log "Created destination directory: $destDir"
        } catch {
            Write-Log "Failed to create directory: $destDir ($($_.Exception.Message))" "ERROR"
            $failed += $sourceRelative
            continue
        }
    }

    try {
        Copy-Item -Path $sourcePath -Destination $destination -Force
        Write-Log "Copied: $sourceRelative -> $destination"
    } catch {
        Write-Log "Failed to copy: $sourceRelative -> $destination ($($_.Exception.Message))" "ERROR"
        $failed += $sourceRelative
    }
}

if ($failed.Count -gt 0) {
    Write-Log "File copy completed with $($failed.Count) failure(s): $($failed -join ', ')" "WARN"
} else {
    Write-Log "All files copied successfully"
}

Write-Log "File copy phase completed"