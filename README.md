# DXpedition Orchestrator

A lightweight automated Windows (Tiny11) deployment system for DXpedition logging PCs.

---

## Purpose

DXpedition Orchestrator automatically installs and configures Windows laptops from a clean Tiny11 installation.

It is designed for a small personal setup (~8 laptops) and focuses on:

- Simplicity
- Repeatability
- Minimal manual work
- Full control via configuration files

---

## What it does

After running this system, a laptop will:

- Have Windows installed and configured
- Have a local administrator account
- Log in automatically
- Be fully configured (display, keyboard, desktop)
- Have required software installed
- Have drivers installed
- Be ready for immediate use

---

## High-level flow

1. Tiny11 USB flash drive is prepared
2. Repository is cloned on the USB flash drive
3. Optionally install packages - executables can be added to the USB flash drive
4. Boot from Tiny11 USB
5. Windows installs automatically
6. Bootstrap runs on first boot
7. Git is installed
8. Repository is cloned for later updates or restores
9. copy installers from USB flash drive into `software/` directory
10. Deploy script runs
11. System is fully configured

---

## One-command deployment

After Windows installation:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\deploy.ps1
```

In most cases, deploy.ps1 is triggered automatically by Bootstrap.

---

## Repository structure

```shell
install/        → Windows installation files (Autounattend, Bootstrap)
scripts/        → All deployment logic (PowerShell)
config/         → YAML configuration files
software/       → Software definitions and installers
hardware/       → Hardware specific notes, how to prepare specific hardware
drivers/        → Optional driver packages
files/          → Files copied to the system
docs/           → Technical documentation
logs/           → Deployment logs
```

---

## Hardware

The hardware directory only contains notes concerning preparing different hardware platforms.

The preparation of the hardware is out of scope of this project and shall be concidered as done.

Exception is the installation of hardware specific drivers which is part of the drivers phase.  Selection of hardware type can be part of a selection menu on initial start of the installation scripts which shall then be saved as part of the configuration.

---

## Configuration

All behavior is controlled via YAML files in:

```shell
config/
```

Example settings:

- keyboard layout
- display scaling
- software list
- desktop settings
- hostname

No hardcoded machine-specific values in scripts.

---

## Adding software

To add software:

1. Add entry in `config/software.yml`
2. use URL defined in `config/software.yml` to download installer.
3. Add installer or script in `software/` if URL not defined
4. Run deployment

No architecture changes required.

---

## Restore system

The system can be reset without reinstalling Windows:

```powershell
.\scripts\restore.ps1
```

This will:

- Reset Windows settings
- Restore configuration
- Reinstall missing software
- Restore files

---

## Requirements

- Windows Tiny11 installed
- Internet connection (DHCP/WiFi)
- Git (installed automatically if missing)

---

## Constraints

This project does NOT use:

- Linux
- WSL
- Ansible (because this needs a Linux server)
- Intune / SCCM / MDT
- Domain controllers
- CI/CD pipelines

Only Windows + PowerShell is used.

---

## Goal

A new laptop should be fully usable with minimal interaction after Windows installation.

---

## Key principle

If something requires manual work after deployment, it is considered a failure.

---

## License

See LICENSE
