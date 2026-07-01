# AGENTS.md
# DXpedition Orchestrator

## Purpose

This project automatically installs and configures Windows (Tiny11) laptops from scratch.

Target:
- ~8 laptops
- Fully automated setup
- Performance-first Windows configuration
- No manual post-install steps except boot + login

## Core Rules

### 1. Simplicity first
Keep everything simple.
No complex frameworks.
No enterprise tooling.

### 2. Single branch only
Only use:
- main

No feature branches, no CI/CD.

### 3. No external orchestration tools
Do NOT use:
- Ansible
- MDT
- Intune
- SCCM
- Linux servers

Everything must run on Windows via PowerShell.

### 4. Git is the source of truth
All configuration, scripts and installers are stored in this repository.

### 5. Automation flow

Target flow:

1. Install Tiny11 via USB
2. Autounattend.xml runs Windows setup
3. Bootstrap.ps1 runs automatically
4. Git repository is cloned
5. Deploy.ps1 runs
6. System is fully configured

### 6. Architecture rules

Keep structure flat and readable:

- install/ → installation files
- scripts/ → all PowerShell logic
- config/ → YAML configuration
- software/ → installers or install logic
- drivers/ → driver packages
- docs/ → documentation

No deeper abstraction layers.

### 7. PowerShell rules

- No complex module architecture required
- Prefer simple .ps1 scripts
- Use functions only when needed
- Always log actions
- Scripts must be readable for non-experts

### 8. Configuration

All configuration must be YAML-based.

Example:
- keyboard layout
- display scaling
- installed software
- desktop settings

### 9. Performance priority

Do not install or enable anything that impacts performance negatively.

Windows must remain lightweight.

### 10. Safety rule

Do not implement Windows activation bypass or license circumvention.
Only support legitimate activation methods (OEM / digital license).

## Success criteria

A laptop is considered successfully deployed when:

- Windows is installed
- User is created (admin)
- Git repository cloned
- Deploy.ps1 executed
- Software installed
- Keyboard + display configured
- System ready for use
