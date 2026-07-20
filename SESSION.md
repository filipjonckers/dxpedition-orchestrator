# Session State — DXpedition Orchestrator

## All phases implemented (2-9)

| Phase | Status | Key files |
|---|---|---|
| 2 Windows Installation | Done | `install/Autounattend.xml`, `docs/boot-usb-drive-tiny11.md` |
| 3 Bootstrap | Done | `scripts/bootstrap.ps1` (WiFi, no Git) |
| 4 Core Deployment | Done | `scripts/deploy.ps1`, `scripts/helpers.ps1` |
| 5 Windows Configuration | Done | `scripts/configure-windows.ps1` (privacy included) |
| 6 Drivers | Done | `scripts/install-drivers.ps1` (WU + local .exe) |
| 7 Software | Done | `scripts/install-software.ps1` (exe + msi, sorted by name) |
| 8 File Copy | Done | `scripts/copy-files.ps1` |
| 9 Restore | Done | `scripts/restore.ps1` |

## Key decisions made during development

- USB-based deployment — no Git dependency
- WiFi configured via `config/wifi.yaml`; Ethernet adapter fallback
- Driver installation: always Windows Update first, then local `.exe` drivers
- Software installation order determined by directory name prefix (`01 vc_redist` before `02 DXLog`)
- MSI installers handled via `msiexec.exe /i`
- Privacy settings: telemetry off, Cortana disabled, advertising ID off
- Hardware type defined in `config/system.yml` (e.g. `HP C1030 Chromebook`)
- Sound driver for C1030 requires purchase — skipped with a README note
- Keyboard: Belgian AZERTY primary, US International secondary, switchable via taskbar

## Bugs fixed during review

- `.gitignore` `software/**/*` pattern excluded parent dirs, causing install.yaml deletion — fixed to `software/*/*` + `!software/*/install.yaml`
- MSHV install.yaml had wrong installer path (`software/MSHV/` prefix doubled)
- DXLog used InnoSetup args (`/VERYSILENT`) for an `.msi` file — changed to `/quiet /norestart`
- `install-drivers.ps1` modes were mutually exclusive — now runs WU then local drivers
- `install-drivers.ps1` local mode used `pnputil` for `.inf` files — now executes `.exe` installers
- `bootstrap.ps1` still referenced Git — removed, replaced with WiFi connection
- `install-software.ps1` had no install order — added `Sort-Object`
- `install-software.ps1` had no MSI handling — added `msiexec.exe /i` for `.msi` files
- `configure-windows.ps1` had no privacy settings — added telemetry, Cortana, advertising ID, hotspot reporting

## Current state

- Branch: `deepseek`
- All 9 roadmap phases implemented
- Phase 10 (testing) ready — test plan at `docs/testing.md`
- No Windows environment available for testing yet
- Next real step: prepare USB, boot laptop, run through test plan checkboxes

## File inventory

```
.
├── AGENTS.md               # Project rules for AI
├── PROJECT.md              # Requirements & scope
├── ROADMAP.md              # Phase tracking (all [x])
├── README.md               # User-facing overview
├── SESSION.md              # THIS FILE - pickup state
├── install/
│   └── Autounattend.xml    # Unattended Windows answer file
├── scripts/
│   ├── bootstrap.ps1       # First-boot prep (WiFi, trigger deploy)
│   ├── deploy.ps1          # Orchestrator (4 phases, critical/non-critical)
│   ├── helpers.ps1         # Write-Log, Read-Yaml
│   ├── configure-windows.ps1  # Scaling, keyboard, desktop, perf, privacy, hostname, tz
│   ├── install-drivers.ps1    # Windows Update + local .exe drivers
│   ├── install-software.ps1   # YAML-driven unattended install (exe + msi, sorted)
│   ├── copy-files.ps1         # Pipe-format file mapping
│   └── restore.ps1            # Re-runs config + software + files
├── config/
│   ├── system.yml           # Hostname, keyboard, scaling, desktop, tz, hardware_type
│   ├── software.yml         # Package list (numbered dir names)
│   ├── wifi.yaml            # WiFi SSID and password
│   └── files.yml            # File mappings (commented examples)
├── software/
│   ├── 01 vc_redist/install.yaml
│   ├── 02 DXLog/install.yaml
│   ├── 04 N1MM-Logger-plus/install.yaml
│   ├── 05 WSJT-X/install.yaml
│   └── 06 MSHV/install.yaml
├── drivers/
│   └── HP C1030 Chromebook/
│       ├── 01 TPM/
│       ├── 03 intel chipset/
│       ├── 04 Sound/README.md
│       ├── 05 Touchpad/
│       └── 06 Touchscreen/
├── files/.gitkeep
├── docs/
│   ├── boot-usb-drive-tiny11.md  # USB preparation guide
│   ├── testing.md                # Test plan with checkboxes
│   └── hardware/
│       └── HP-Elite-C1030-chromebook.md
```

## When resuming

1. Read AGENTS.md + ROADMAP.md + SESSION.md
2. Phase 10 starts — user needs to run tests on Windows/Tiny11 hardware
3. Mark checkboxes in docs/testing.md as tests pass
4. If bugs found during testing, fix them in the relevant script
5. Phase 11 (optional improvements) is deferred — do NOT implement unless asked