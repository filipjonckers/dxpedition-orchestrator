# ROADMAP

## Expedition Orchestrator

---

## Goal

Build a simple, reliable Windows (Tiny11) deployment system that fully configures a laptop using:

- Bootstrap (first boot)
- Git repository
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

- Write how to adapt the Tiny11 USB installer in boot.md
- Configure Tiny11 USB installer
- Add Autounattend.xml
- Enable automatic partitioning
- Create local administrator account
- Enable automatic login

Result:

Windows installs without manual input.

---

## Phase 3 — Bootstrap System

Goal: prepare Windows for deployment after first boot.

Tasks:

- Create bootstrap.ps1
- Install or update Git if missing
- Configure execution policy
- Clone or update repository
- Create logs directory
- Start deploy.ps1 automatically

Result:

System prepares itself after Windows installation.

---

## Phase 4 — Core Deployment Engine

Goal: main deployment logic.

Tasks:

- Create deploy.ps1
- Load YAML configuration
- Execute scripts in correct order:
  - configure-windows.ps1
  - install-drivers.ps1
  - install-software.ps1
  - copy-files.ps1
- Implement logging

Result:

Single script can fully configure system.

---

## Phase 5 — Windows Configuration

Goal: apply system settings.

Tasks:

- Set display scaling (150%)
- Set black desktop background (#000000)
- Disable wallpaper
- Configure keyboard:
  - Belgian AZERTY
  - US International secondary
- Apply performance settings

Result:

System is visually and functionally configured.

---

## Phase 6 — Drivers

Goal: optional driver installation.

Tasks:

- Implement install-drivers.ps1
- Use Windows Update first
- Use local drivers/ folder if available
- Skip if nothing is available

Result:

Drivers installed when needed without breaking deployment.

---

## Phase 7 — Software Installation

Goal: install required applications.

Tasks:

- Implement install-software.ps1
- Add support for YAML-based software list
- Install initial applications:
  - N1MM Logger+
  - MSHV
  - WSJT-X
  - DXLog

Result:

Software installs automatically based on config.

---

## Phase 8 — File Deployment

Goal: copy configuration files.

Tasks:

- Implement copy-files.ps1
- Map files/ folder to system paths
- Support YAML-based file mapping

Result:

All required files available on system.

---

## Phase 9 — Restore System

Goal: allow system reset without reinstalling Windows.

Tasks:

- Implement restore.ps1
- Reset Windows settings
- Reapply configuration
- Reinstall missing software
- Restore files

Result:

System can be reset to clean state.

---

## Phase 10 — Testing & Stabilization

Goal: ensure reliability across multiple laptops.

Tasks:

- Test full installation flow
- Test reinstall scenario
- Test restore scenario
- Verify logging
- Fix edge cases

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
