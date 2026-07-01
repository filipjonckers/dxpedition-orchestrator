# PROJECT

## Goal

Build a fully automated Windows deployment system for Tiny11 laptops.

---

## Requirements

- Automatic installation of Windows
- Automatic user creation (admin)
- Automatic system configuration
- Automatic software installation
- Automatic keyboard + display setup
- Automatic driver handling
- Git-based configuration system

---

## Environment constraints

- No Linux required
- No Ansible
- No external orchestration systems
- Only Windows PowerShell allowed
- Internet available via DHCP/WiFi

---

## Software scope

Initial applications:

- N1MM Logger+
- WSJT-X
- DXLog

---

## Configuration system

All configuration stored in YAML files:
- keyboard layout
- display scaling
- desktop settings
- installed software

---

## Deployment requirement

System must be fully usable after:

- Windows install
- Bootstrap execution
- One deploy script run
