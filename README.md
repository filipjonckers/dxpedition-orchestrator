# DXpedition Orchestrator

Orchestration of DXpedition notebooks for the RockAll DXpedition team.

## Goal

Fully automatic installation and configuration of Windows laptops using:
- PowerShell
- GitHub repository
- YAML configuration

No manual setup after boot.

---

## Flow

1. Boot USB (Tiny11)
2. Windows installs automatically
3. Bootstrap runs
4. Repository is cloned
5. Deploy script runs
6. System is ready

---

## Structure

- install/ → Windows setup files
- scripts/ → PowerShell logic
- config/ → YAML configuration
- software/ → software installers
- drivers/ → drivers
- docs/ → documentation

---

## Usage

After installation:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Deploy.ps1
```
