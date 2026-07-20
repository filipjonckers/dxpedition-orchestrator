. "C:\dxpedition-orchestrator\scripts\helpers.ps1"

Write-Log "Driver installation phase started"

$config = Read-Yaml -Path "C:\dxpedition-orchestrator\config\system.yml"
$driverDir = "C:\dxpedition-orchestrator\drivers"

Write-Log "Step 1: Windows Update driver scan"

try {
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()

    Write-Log "Scanning for available driver updates"
    $searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Driver'")

    if ($searchResult.Updates.Count -eq 0) {
        Write-Log "No driver updates found via Windows Update"
    } else {
        Write-Log "Found $($searchResult.Updates.Count) driver update(s)"

        $updatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
        foreach ($update in $searchResult.Updates) {
            $updatesToDownload.Add($update) | Out-Null
            Write-Log "  Driver: $($update.Title)"
        }

        $downloader = $updateSession.CreateUpdateDownloader()
        $downloader.Updates = $updatesToDownload
        Write-Log "Downloading driver updates"
        $downloadResult = $downloader.Download()

        if ($downloadResult.ResultCode -eq 2) {
            Write-Log "Driver downloads completed"

            $installer = $updateSession.CreateUpdateInstaller()
            $installer.Updates = $updatesToDownload
            Write-Log "Installing driver updates"
            $installResult = $installer.Install()

            Write-Log "Driver installation result: $($installResult.ResultCode)"
            if ($installResult.RebootRequired) {
                Write-Log "Reboot required for some drivers" "WARN"
            }
        } else {
            Write-Log "Driver download result: $($downloadResult.ResultCode)" "WARN"
        }
    }
} catch {
    Write-Log "Windows Update driver scan failed: $($_.Exception.Message)" "WARN"
}

Write-Log "Step 2: Local driver installation"

$hardwareType = if ($config.ContainsKey("hardware_type")) { $config["hardware_type"] } else { "" }

if ($hardwareType -eq "") {
    Write-Log "No hardware_type defined in system.yml, skipping local drivers" "WARN"
    Write-Log "Driver installation phase completed"
    return
}

$hardwareDriverDir = "$driverDir\$hardwareType"

if (-not (Test-Path $hardwareDriverDir)) {
    Write-Log "Driver directory not found: $hardwareDriverDir" "WARN"
    Write-Log "Driver installation phase completed"
    return
}

Write-Log "Installing drivers for hardware: $hardwareType"

$driverDirs = Get-ChildItem -Path $hardwareDriverDir -Directory | Sort-Object Name

if ($driverDirs.Count -eq 0) {
    Write-Log "No driver subdirectories found in $hardwareDriverDir"
    Write-Log "Driver installation phase completed"
    return
}

Write-Log "Found $($driverDirs.Count) driver subdirectories"

$failed = @()

foreach ($dir in $driverDirs) {
    Write-Log "Processing driver directory: $($dir.Name)"
    $exeFiles = Get-ChildItem -Path $dir.FullName -Filter "*.exe"

    if ($exeFiles.Count -eq 0) {
        Write-Log "  No .exe installer found in $($dir.Name), skipping"
        continue
    }

    foreach ($exe in $exeFiles) {
        Write-Log "  Installing driver: $($exe.Name)"
        try {
            $process = Start-Process -FilePath $exe.FullName -Wait -NoNewWindow -PassThru
            if ($process.ExitCode -eq 0) {
                Write-Log "  Driver '$($exe.Name)' — installed (exit code: 0)"
            } else {
                Write-Log "  Driver '$($exe.Name)' — installation failed (exit code: $($process.ExitCode))" "WARN"
                $failed += "$($dir.Name)\$($exe.Name)"
            }
        } catch {
            Write-Log "  Driver '$($exe.Name)' — error: $($_.Exception.Message)" "WARN"
            $failed += "$($dir.Name)\$($exe.Name)"
        }
    }
}

if ($failed.Count -gt 0) {
    Write-Log "Local driver installation completed with $($failed.Count) failure(s): $($failed -join ', ')" "WARN"
} else {
    Write-Log "All local drivers installed successfully"
}

Write-Log "Driver installation phase completed"