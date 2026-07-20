# Test Plan — DXpedition Orchestrator

Run through each test after preparing a Tiny11 USB drive following [boot.md](boot.md).

---

## 1. USB Preparation

- [ ] Tiny11 ISO downloaded from official source
- [ ] USB flashed with Rufus (GPT, UEFI, remove TPM/Secure Boot requirements)
- [ ] `install/Autounattend.xml` copied to USB root, renamed to `autounattend.xml`
- [ ] Project directory copied to USB: `X:\dxpedition-orchestrator`
- [ ] Software installers copied to their respective `software/<package>/` directories on USB
- [ ] `config/wifi.yaml` configured if WiFi is needed, or USB-C Ethernet adapter available

---

## 2. Windows Installation

- [ ] Laptop boots from USB
- [ ] Windows installs without any manual input
- [ ] Drive is partitioned automatically (EFI 100MB + MSR 16MB + NTFS rest)
- [ ] Compact OS is enabled (reduced disk footprint)
- [ ] Local administrator `dxpedition` account is created
- [ ] Automatic login works (no password prompt at boot)
- [ ] Belgian AZERTY keyboard is active during setup
- [ ] Timezone is set to UTC
- [ ] Windows boots to desktop without OOBE prompts

---

## 3. Bootstrap

- [ ] `bootstrap.ps1` runs automatically on first logon
- [ ] Log file created at `C:\dxpedition-orchestrator\logs\deploy.log`
- [ ] PowerShell execution policy set to `RemoteSigned`
- [ ] WiFi connection attempt logged (success or fallback to Ethernet)
- [ ] `deploy.ps1` starts automatically after bootstrap completes

---

## 4. Deployment Orchestration

- [ ] `deploy.ps1` loads `config/system.yml`
- [ ] `deploy.ps1` loads `config/software.yml`
- [ ] `deploy.ps1` loads `config/files.yml`
- [ ] All four phases execute in order
- [ ] Failed critical phases stop deployment
- [ ] Failed non-critical phases (drivers) log warning and continue

---

## 5. Windows Configuration

- [ ] Display scaling set to 150% (LogPixels = 144)
- [ ] Computer name set to value from `config/system.yml`
- [ ] Timezone set to UTC
- [ ] Primary keyboard: Belgian AZERTY (`0813:00000813`)
- [ ] Secondary keyboard: US International (`0409:00000409`)
- [ ] Language selector visible in taskbar
- [ ] Desktop background: solid black (`#000000`)
- [ ] Wallpaper disabled
- [ ] Performance settings applied (visual effects minimized)
- [ ] Telemetry disabled (`AllowTelemetry = 0`)
- [ ] Cortana disabled (`AllowCortana = 0`)
- [ ] Advertising ID disabled (`DisabledByGroupPolicy = 1`)
- [ ] Wi-Fi hotspot reporting disabled

---

## 6. Driver Installation

Drivers are installed in two steps:

### Step 1: Windows Update

- [ ] Windows Update COM API scan runs without error
- [ ] Available driver updates are found (or "no updates" logged)
- [ ] Driver downloads and installation proceed
- [ ] Reboot logged if required

### Step 2: Local Drivers

- [ ] `hardware_type` is read from `config/system.yml`
- [ ] Correct `drivers/<hardware_type>/` directory is located
- [ ] Numbered subdirectories are processed in order
- [ ] `.exe` drivers are installed via `Start-Process -Wait`
- [ ] Exit code checked and logged
- [ ] Missing directories or missing `.exe` files are skipped with log warning

---

## 7. Software Installation

- [ ] Packages are installed in directory name order (`01` before `02` before `04`...)

Test each enabled package from `config/software.yml`:

- [ ] Package without installer on disk and no URL → logged as skipped
- [ ] Package `.exe` with installer on disk → installed with configured arguments
- [ ] Package `.msi` with installer on disk → installed via `msiexec.exe /i`
- [ ] Exit code checked: 0 = success, non‑zero = logged as failure
- [ ] Already‑installed package (detected via `expected_path`) → skipped
- [ ] Failed package reported in summary

### Per‑package verification

- [ ] **Visual C++ Redistributable** installed
- [ ] **DXLog** launches and shows main window
- [ ] **N1MM Logger+** launches and shows main window
- [ ] **WSJT-X** launches and shows main window
- [ ] **MSHV** launches and shows main window

---

## 8. File Copy

- [ ] Files defined in `config/files.yml` are copied from `files/` to target paths
- [ ] Destination directories are created automatically when missing
- [ ] Missing source files log a warning but don't block other copies
- [ ] Failures are reported in the summary

---

## 9. Restore

- [ ] `restore.ps1` runs from an already-configured laptop
- [ ] Windows configuration is reapplied
- [ ] Missing software is reinstalled
- [ ] Files are restored
- [ ] No reboot required during restore
- [ ] Log written to same `logs/deploy.log`

---

## 10. Logging Verification

- [ ] Single log file at `C:\dxpedition-orchestrator\logs\deploy.log`
- [ ] Every log line contains: timestamp, caller script, level, message
- [ ] Errors include exception details
- [ ] No duplicate or orphan log files

---

## 11. Error Handling

- [ ] Remove USB drive during deployment → deployment continues with logged errors
- [ ] Disable network → WiFi fails gracefully, deployment continues
- [ ] Corrupt installer file → logged as error, does not crash deploy.ps1
- [ ] Missing YAML config → defaults used, warning logged
- [ ] Missing driver `.exe` → skipped with log warning

---

## 12. Idempotency (Re‑run Safety)

- [ ] Run `deploy.ps1` twice on the same system:
  - [ ] Second run does not duplicate registry changes
  - [ ] Already‑installed software is skipped
  - [ ] Files are overwritten without errors
- [ ] Run `restore.ps1` after deployment → same result as fresh deployment