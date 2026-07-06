. "C:\dxpedition-orchestrator\scripts\helpers.ps1"

Write-Log "Driver installation phase started"

$config = Read-Yaml -Path "C:\dxpedition-orchestrator\config\system.yml"
$driverMode = if ($config.ContainsKey("driver_mode")) { $config["driver_mode"] } else { "windows_update" }

Write-Log "Driver mode: $driverMode"

switch ($driverMode) {
    "skip" {
        Write-Log "Driver installation skipped per configuration"
    }

    "windows_update" {
        Write-Log "Searching Windows Update for driver updates"

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
    }

    "local" {
        $driverPath = "C:\dxpedition-orchestrator\drivers"

        if (-not (Test-Path $driverPath)) {
            Write-Log "Local driver folder not found: $driverPath" "WARN"
            Write-Log "No local drivers to install"
        } else {
            $driverCount = (Get-ChildItem -Path $driverPath -Filter "*.inf" -Recurse).Count
            if ($driverCount -eq 0) {
                Write-Log "No .inf driver files found in $driverPath"
            } else {
                Write-Log "Found $driverCount driver package(s) in $driverPath"
                Write-Log "Installing drivers with pnputil"

                try {
                    $result = pnputil /add-driver "$driverPath\*.inf" /subdirs /install 2>&1
                    foreach ($line in $result) {
                        Write-Log "pnputil: $line"
                    }
                    Write-Log "Local driver installation completed"
                } catch {
                    Write-Log "Local driver installation failed: $($_.Exception.Message)" "WARN"
                }
            }
        }
    }

    default {
        Write-Log "Unknown driver mode: $driverMode" "WARN"
        Write-Log "Valid options: windows_update, local, skip"
    }
}

Write-Log "Driver installation phase completed"