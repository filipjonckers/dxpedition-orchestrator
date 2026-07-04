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

1. Boot from Tiny11 USB
2. Windows installs automatically
3. Bootstrap runs on first boot
4. Git is installed
5. Repository is cloned or updated
6. Deploy script runs
7. System is fully configured

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
drivers/        → Optional driver packages
files/          → Files copied to the system
docs/           → Technical documentation
logs/           → Deployment logs
```

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
