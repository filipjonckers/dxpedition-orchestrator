$Global:LogFile = "C:\dxpedition-orchestrator\logs\deploy.log"

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $caller = (Get-PSCallStack)[1].Command
    $line = "$timestamp [$caller] [$Level] $Message"
    Write-Output $line

    $logDir = Split-Path $Global:LogFile -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }

    $line | Out-File -FilePath $Global:LogFile -Encoding UTF8 -Append
}

function Read-Yaml {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        Write-Log "YAML file not found: $Path" "WARN"
        return @{}
    }

    $result = @{}
    $currentKey = $null
    $currentList = $null

    Get-Content $Path | ForEach-Object {
        $line = $_
        if ($line -match "^\s*#") { return }
        if ($line -match "^\s*$") { return }

        if ($line -match "^\s*-\s+(.+)$") {
            $value = $matches[1].Trim()
            if ($value -match '^"(.+)"$' -or $value -match "^'(.+)'$") {
                $value = $matches[1]
            }
            if ($currentKey -and $currentList -ne $null) {
                $currentList += $value
            }
            return
        }

        if ($line -match "^\s*([^:]+):\s*(.*)$") {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()

            if ($value -eq "") {
                $currentKey = $key
                $currentList = @()
                $result[$key] = $currentList
            } else {
                if ($value -match '^"(.+)"$' -or $value -match "^'(.+)'$") {
                    $value = $matches[1]
                }
                $result[$key] = $value
            }
        }
    }

    return $result
}