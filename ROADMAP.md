# ROADMAP

## Expedition Orchestrator

---

## Goal

Build a simple, reliable Windows (Tiny11) deployment system that fully configures a laptop using:

- Bootstrap (first boot)
- USB-based deployment (no Git dependency)
- PowerShell scripts
- YAML configuration files

No external infrastructure is required.

---

## General Principle

Each phase must be:

- simple
- testable
- usable before moving to the next phase

Do not move forward if the current phase does not work.

---

## Phase 1 — Repository Setup

Goal: create a clean, minimal project structure.

Tasks:

[x] Create GitHub repository
[x] Add base folder structure
[x] Add AGENTS.md
[x] Add PROJECT.md
[x] Add ROADMAP.md
[x] Add README.md
[x] Add .gitignore
[x] Add hardware specific notes

Result:

A clean repository ready for implementation.

---

## Phase 2 — Windows Installation (Tiny11)

Goal: fully automatic Windows installation.

Tasks:

[x] Write how to adapt the Tiny11 USB installer in boot.md
[x] Configure Tiny11 USB installer
[x] Add Autounattend.xml
[x] Enable automatic partitioning
[x] Enable Compact OS install
[x] Create local administrator account
[x] Enable automatic login

Result:

Windows installs without manual input.

---

## Phase 3 — Bootstrap System

Goal: prepare Windows for deployment after first boot.

Tasks:

[x] Create bootstrap.ps1
[x] Connect to WiFi if configured in `config/wifi.yaml`
[x] Configure execution policy
[x] Create logs directory
[x] Start deploy.ps1 automatically

Result:

System prepares itself after Windows installation.

---

## Phase 4 — Core Deployment Engine

Goal: main deployment logic.

Tasks:

[x] Create deploy.ps1
[x] Load YAML configuration
[x] Execute scripts in correct order:
  - configure-windows.ps1
  - install-drivers.ps1
  - install-software.ps1
  - copy-files.ps1
[x] Implement logging

Result:

Single script can fully configure system.

---

## Phase 5 — Windows Configuration

Goal: apply system settings.

Tasks:

[x] Set display scaling (150%)
[x] Set black desktop background (#000000)
[x] Disable wallpaper
[x] Configure keyboard:
    - Belgian AZERTY
    - US International secondary
[x] Apply performance settings
[x] Disable telemetry, Cortana, advertising ID
[x] Show file name extensions in Explorer
[x] Remove Microsoft Store icon from taskbar

Result:

System is visually and functionally configured.

---

## Phase 6 — Drivers

Goal: optional driver installation.

Tasks:

[x] Implement install-drivers.ps1
[x] Always run Windows Update first
[x] Install local `.exe` drivers from `drivers/<hardware_type>/` numbered subdirectories
[x] Skip missing directories gracefully

Result:

Drivers installed when needed without breaking deployment.

---

## Phase 7 — Software Installation

Goal: install required applications.

Tasks:

[x] Implement install-software.ps1
[x] Add support for YAML-based software list
[x] Installation order determined by directory name prefix
[x] Support both `.exe` and `.msi` installers
[x] Install initial applications:
    - Visual C++ Redistributable
    - DXLog
    - N1MM Logger+
    - WSJT-X
    - MSHV

Result:

Software installs automatically based on config.

---

## Phase 8 — File Deployment

Goal: copy configuration files.

Tasks:

[x] Implement copy-files.ps1
[x] Map files/ folder to system paths
[x] Support YAML-based file mapping

Result:

All required files available on system.

---

## Phase 9 — Restore System

Goal: allow system reset without reinstalling Windows.

Tasks:

[x] Implement restore.ps1
[x] Reset Windows settings
[x] Reapply configuration
[x] Reinstall missing software
[x] Restore files

Result:

System can be reset to clean state.

---

## Phase 10 — Testing & Stabilization

Goal: ensure reliability across multiple laptops.

Tasks:

[ ] Test full installation flow
[ ] Test WiFi connection
[ ] Test driver installation (Windows Update + local)
[ ] Test software installation (exe + msi)
[ ] Test privacy settings
[ ] Test reinstall scenario
[ ] Test restore scenario
[ ] Verify logging
[ ] Fix edge cases

Result:

Stable, repeatable deployment system.

---

## Phase 11 — Optional Improvements

Only implement if required.

Possible additions:

- additional software modules
- new hardware support
- improved logging
- configuration refinements

Do NOT add complexity without need.

---

## Completion Criteria

The project is complete when:

- A new laptop can be installed from USB
- No manual configuration is required after Windows setup
- Running deploy.ps1 results in a fully configured system
- All configuration is controlled via YAML
- The system can be restored without reinstalling Windows

---

## Final Rule

Do not advance phases unless the current phase is fully working and tested.