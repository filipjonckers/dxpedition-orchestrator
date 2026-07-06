. "C:\dxpedition-orchestrator\scripts\helpers.ps1"

Write-Log "Windows configuration phase started"

$configPath = "C:\dxpedition-orchestrator\config\system.yml"
$config = Read-Yaml -Path $configPath

if ($config.Count -eq 0) {
    Write-Log "No configuration found, using defaults" "WARN"
}

$displayScaling = if ($config.ContainsKey("display_scaling")) { $config["display_scaling"] } else { "150" }
$keyboardLayout = if ($config.ContainsKey("keyboard_layout")) { $config["keyboard_layout"] } else { "0813:00000813" }
$secondaryKeyboard = if ($config.ContainsKey("secondary_keyboard")) { $config["secondary_keyboard"] } else { "0409:00000409" }
$desktopBackground = if ($config.ContainsKey("desktop_background")) { $config["desktop_background"] } else { "#000000" }
$hostname = if ($config.ContainsKey("hostname")) { $config["hostname"] } else { "" }
$timezone = if ($config.ContainsKey("timezone")) { $config["timezone"] } else { "" }

if ($hostname -ne "") {
    Write-Log "Setting computer name to $hostname"
    try {
        Rename-Computer -NewName $hostname -Force
        Write-Log "Computer name set to $hostname (applies after reboot)"
    } catch {
        Write-Log "Failed to set computer name: $($_.Exception.Message)" "WARN"
    }
}

if ($timezone -ne "") {
    Write-Log "Setting timezone to $timezone"
    try {
        Set-TimeZone -Name $timezone
        Write-Log "Timezone set to $timezone"
    } catch {
        Write-Log "Failed to set timezone: $($_.Exception.Message)" "WARN"
    }
}

Write-Log "Setting display scaling to $displayScaling%"

try {
    $logPixels = [math]::Round(96 * [int]$displayScaling / 100)
    $scaleRegPath = "HKCU:\Control Panel\Desktop"
    Set-ItemProperty -Path $scaleRegPath -Name "LogPixels" -Value $logPixels -Type DWord -Force
    Set-ItemProperty -Path $scaleRegPath -Name "Win8DpiScaling" -Value 1 -Type DWord -Force
    Write-Log "Display scaling set (LogPixels: $logPixels)"
} catch {
    Write-Log "Failed to set display scaling: $($_.Exception.Message)" "ERROR"
}

Write-Log "Configuring keyboard layouts"

try {
    $langList = New-WinUserLanguageList -Language "en-US" -Force
    $langList[0].InputMethodTips.Clear()
    $langList[0].InputMethodTips.Add($keyboardLayout)
    $langList[0].InputMethodTips.Add($secondaryKeyboard)
    Set-WinUserLanguageList -LanguageList $langList -Force
    Write-Log "Keyboard layouts configured"
} catch {
    Write-Log "Failed to set keyboard layouts: $($_.Exception.Message)" "ERROR"
}

Write-Log "Setting desktop background to $desktopBackground"

try {
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value 2 -Type DWord -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value "" -Type String -Force

    $rgb = $desktopBackground -replace "#", ""
    if ($rgb.Length -eq 6) {
        $r = [Convert]::ToByte($rgb.Substring(0, 2), 16)
        $g = [Convert]::ToByte($rgb.Substring(2, 2), 16)
        $b = [Convert]::ToByte($rgb.Substring(4, 2), 16)
        Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name "Background" -Value "$r $g $b" -Force
    }
    Write-Log "Desktop background set to solid black"
} catch {
    Write-Log "Failed to set desktop background: $($_.Exception.Message)" "ERROR"
}

try {
    $policyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
    if (-not (Test-Path $policyPath)) {
        New-Item -Path $policyPath -Force | Out-Null
    }
    Set-ItemProperty -Path $policyPath -Name "NoChangingWallPaper" -Value 1 -Type DWord -Force
    Write-Log "Wallpaper disabled"
} catch {
    Write-Log "Failed to disable wallpaper: $($_.Exception.Message)" "WARN"
}

Write-Log "Applying performance settings"

try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuAnimation" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ComboBoxAnimation" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ListBoxSmoothScrolling" -Value 0 -Type DWord -Force
    Write-Log "Performance settings applied"
} catch {
    Write-Log "Failed to apply performance settings: $($_.Exception.Message)" "WARN"
}

Write-Log "Windows configuration phase completed"