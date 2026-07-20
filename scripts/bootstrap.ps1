$RepoPath = "C:\dxpedition-orchestrator"
$LogDir = "$RepoPath\logs"
$LogFile = "$LogDir\deploy.log"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$timestamp [Bootstrap] [$Level] $Message"
    Write-Output $line
    $line | Out-File -FilePath $LogFile -Encoding UTF8 -Append
}

Write-Log "Bootstrap started"

Write-Log "Setting PowerShell execution policy"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

$wifiConfig = "$RepoPath\config\wifi.yaml"
if (Test-Path $wifiConfig) {
    Write-Log "WiFi configuration found, attempting to connect"

    $wifiContent = Get-Content $wifiConfig -Raw
    $ssid = if ($wifiContent -match 'ssid:\s*"([^"]*)"') { $matches[1] } else { "" }
    $password = if ($wifiContent -match 'password:\s*"([^"]*)"') { $matches[1] } else { "" }

    if ($ssid -ne "" -and $password -ne "") {
        Write-Log "Connecting to WiFi network: $ssid"

        $profileXml = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$ssid</name>
    <SSIDConfig>
        <SSID>
            <name>$ssid</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$password</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
"@
        $profilePath = "$env:TEMP\wifi-profile.xml"
        $profileXml | Out-File -FilePath $profilePath -Encoding UTF8 -Force

        try {
            $addResult = netsh wlan add profile filename="$profilePath" 2>&1
            Write-Log "WiFi profile added: $addResult"
            $connectResult = netsh wlan connect name="$ssid" 2>&1
            Write-Log "WiFi connect result: $connectResult"
        } catch {
            Write-Log "WiFi connection failed: $($_.Exception.Message)" "WARN"
        }

        Remove-Item $profilePath -Force -ErrorAction SilentlyContinue
    } else {
        Write-Log "WiFi config incomplete (ssid or password missing)" "WARN"
        Write-Log "Expecting USB-C Ethernet adapter"
    }
} else {
    Write-Log "No WiFi configuration found at $wifiConfig"
    Write-Log "Expecting USB-C Ethernet adapter"
}

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

Write-Log "Bootstrap completed successfully"

$deployScript = "$RepoPath\scripts\deploy.ps1"
if (Test-Path $deployScript) {
    Write-Log "Starting deploy.ps1"
    & $deployScript
} else {
    Write-Log "deploy.ps1 not found at $deployScript" "ERROR"
}