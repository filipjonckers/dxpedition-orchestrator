# DXpedition Orchestrator

A lightweight automated Windows (Tiny11) deployment system for DXpedition logging PCs.

---

## Purpose

DXpedition Orchestrator automatically installs and configures Windows laptops from a clean Tiny11 installation.

It is designed for a small personal setup (8 to 10 laptops) and focuses on:

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
- Be fully configured (display, keyboard, desktop, privacy)
- Have required software installed
- Have drivers installed (Windows Update + local)
- Be ready for immediate use

---

## High-level flow

1. Tiny11 USB flash drive is prepared
2. Project directory is copied to the USB flash drive
3. Installer executables are copied to `software/<package>/` directories
4. Boot from Tiny11 USB
5. Windows installs automatically
6. Bootstrap runs on first boot, connects to WiFi if configured
7. Deploy script runs
8. System is configured, drivers installed, software installed, files copied
9. System is fully configured

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
software/       → Software definitions and installers — one subdirectory per package
hardware/       → Hardware specific notes, how to prepare specific hardware
drivers/        → Driver packages — one subdirectory per hardware type
files/          → Files copied to the system
docs/           → Technical documentation
logs/           → Deployment logs
```

---

## Hardware

The hardware directory only contains notes concerning preparing different hardware platforms.

The preparation of the hardware is out of scope of this project and shall be considered as done.

Exception is the installation of hardware specific drivers which is part of the drivers phase. Hardware type is defined in `config/system.yml`.

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
- WiFi SSID and password
- hardware type

No hardcoded machine-specific values in scripts.

---

## Adding software

To add software:

1. Create a directory in `software/` with a numbered prefix (e.g. `03 my-app`)
2. Add `install.yaml` with installer name, arguments, and expected path
3. Copy the installer executable (`.exe` or `.msi`) into the directory
4. Add the directory name to `config/software.yml`
5. Run deployment

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
- Network connection: WiFi (configured via `config/wifi.yaml`) or USB-C Ethernet adapter
- DHCP enabled

---

## Constraints

This project does NOT use:

- Linux
- WSL
- Ansible
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