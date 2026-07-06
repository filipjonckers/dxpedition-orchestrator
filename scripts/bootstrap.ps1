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

$gitAvailable = Get-Command git -ErrorAction SilentlyContinue

if (-not $gitAvailable) {
    Write-Log "Git not found, attempting installation" "WARN"

    $gitInstallerPath = "$RepoPath\software\Git"
    $gitInstaller = Get-ChildItem -Path $gitInstallerPath -Filter "*.exe" | Select-Object -First 1
    if ($gitInstaller) {
        Write-Log "Installing Git from $($gitInstaller.FullName)"
        Start-Process -FilePath $gitInstaller.FullName -ArgumentList "/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS='ext,ext\shellhere,ext\githere,gitlfs,assoc' /LOG=$LogDir\git-install.log" -Wait -NoNewWindow
        Write-Log "Git installation completed"
    } else {
        Write-Log "Local Git installer not found in $gitInstallerPath" "WARN"
        Write-Log "Attempting Git install via winget"
        $wingetResult = winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements 2>&1
        Write-Log "winget result: $wingetResult"
    }
} else {
    Write-Log "Git is already installed"
}

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

$gitAvailable = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitAvailable) {
    Write-Log "Git is not available after installation attempt" "ERROR"
    Write-Log "Deployment will continue without Git updates"
} else {
    Write-Log "Git is available: $(git --version)"
    $gitDir = "$RepoPath\.git"
    if (Test-Path $gitDir) {
        Write-Log "Repository has Git metadata, pulling latest changes"
        Push-Location $RepoPath
        git pull 2>&1 | ForEach-Object { Write-Log "git pull: $_" }
        Pop-Location
        Write-Log "Repository update completed"
    } else {
        Write-Log "Repository was copied from USB (no Git metadata), skipping pull"
    }
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