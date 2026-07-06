# Test Plan — DXpedition Orchestrator

Run through each test after preparing a Tiny11 USB drive following [boot.md](boot.md).

---

## 1. USB Preparation

- [ ] Tiny11 ISO downloaded from official source
- [ ] USB flashed with Rufus (GPT, UEFI, remove TPM/Secure Boot requirements)
- [ ] `install/Autounattend.xml` copied to USB root, renamed to `autounattend.xml`
- [ ] Repository cloned to USB: `git clone <url> X:\dxpedition-orchestrator`
- [ ] Git installer (e.g. `Git-*.exe`) copied to `software/Git/` on USB (if no internet during deployment)
- [ ] Software installers copied to their respective `software/<package>/` directories on USB

---

## 2. Windows Installation

- [ ] Laptop boots from USB
- [ ] Windows installs without any manual input
- [ ] Drive is partitioned automatically (EFI + MSR + NTFS)
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
- [ ] Git installation:
  - [ ] Installed from USB `software/Git/` when no internet, OR
  - [ ] Installed via winget when internet available, OR
  - [ ] Skipped if already installed
- [ ] Repository pulled if `.git` exists, skipped if copied from USB without Git metadata
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

---

## 6. Driver Installation

Test each `driver_mode` from `config/system.yml`:

### `driver_mode: windows_update`

- [ ] Windows Update COM API scan runs without error
- [ ] Available driver updates are found (or "no updates" logged)
- [ ] Driver downloads and installation proceed
- [ ] Reboot logged if required

### `driver_mode: local`

- [ ] `/drivers/` folder is scanned for `.inf` files
- [ ] `pnputil /add-driver` runs without error
- [ ] Exit code checked and logged

### `driver_mode: skip`

- [ ] Driver installation phase skips immediately
- [ ] Log confirms "Driver installation skipped per configuration"

---

## 7. Software Installation

Test each enabled package from `config/software.yml`:

- [ ] Package without installer on disk and no URL → logged as skipped
- [ ] Package with installer on disk → installed with configured arguments
- [ ] Exit code checked: 0 = success, non‑zero = logged as failure
- [ ] Already‑installed package (detected via `expected_path`) → skipped
- [ ] Failed package reported in summary

### Per‑package verification

- [ ] **N1MM Logger+** launches and shows main window
- [ ] **WSJT-X** launches and shows main window
- [ ] **MSHV** launches and shows main window
- [ ] **DXLog** launches and shows main window

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
- [ ] Disable network → winget/Git pull fail gracefully, deployment continues
- [ ] Corrupt installer file → logged as error, does not crash deploy.ps1
- [ ] Missing YAML config → defaults used, warning logged

---

## 12. Idempotency (Re‑run Safety)

- [ ] Run `deploy.ps1` twice on the same system:
  - [ ] Second run does not duplicate registry changes
  - [ ] Already‑installed software is skipped
  - [ ] Files are overwritten without errors
- [ ] Run `restore.ps1` after deployment → same result as fresh deployment