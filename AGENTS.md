# AGENTS.md

# DXpedition Orchestrator

## Purpose

DXpedition Orchestrator is a lightweight Windows deployment toolkit for Tiny11 laptops.

It automatically installs, configures and prepares Windows systems using PowerShell and configuration files stored in a separate directory on the installation USB flash drive.

Target environment:

- 8 to 10 laptops
- Personal use
- No enterprise infrastructure

---

## Core Rule

This project must remain simple.

If a solution increases complexity without clear benefit, it must NOT be implemented.

---

## System Overview

Deployment flow:

1. Tiny11 installs Windows automatically
2. bootstrap.ps1 runs on first boot
3. deploy.ps1 is executed
4. System is configured
5. Drivers are installed
6. Software is installed
7. Software is configured
8. Deployment completes

---

## Hard Constraints

Never introduce:

- Linux
- WSL
- Ansible
- MDT / SCCM / Intune
- Active Directory
- CI/CD pipelines
- Multi-branch Git workflows
- Complex module frameworks
- Package managers unless explicitly added later

Only use:

- PowerShell
- Windows built-in tools
- YAML configuration files

---

## Git Rules

- The project is managed in a Git repository
- Only work in the current branch
- No new feature branches
- No new release branches
- No Git workflows
- Repository is single source of truth

**important**
the Git repository shall not contain installers.

---

## Architecture Rules

### Simplicity

Prefer:

- fewer scripts
- fewer abstractions
- explicit logic

Avoid:

- frameworks
- plugin systems
- dynamic module loaders
- complex object-oriented design

### Directory Structure

Keep structure flat and readable:

- install/ → installation files
- scripts/ → all PowerShell logic
- config/ → YAML configuration
- software/ → installers or install logic - one sub directory per package
- hardware/ → hardware preparation notes
- drivers/ → driver packages - one sub directory per driver
- files/ → files copied to the system
- docs/ → documentation
- logs/ → deployment logs

No deeper abstraction layers.

### Script Structure

Scripts must remain simple and readable.

Preferred structure:

- bootstrap.ps1 → prepares system
- deploy.ps1 → main orchestrator
- configure-windows.ps1 → OS settings
- install-drivers.ps1 → driver handling
- install-software.ps1 → software installation
- copy-files.ps1 → file deployment
- restore.ps1 → reset system
- helpers.ps1 → shared functions

Each script has ONE responsibility.

---

### File Size Rule

Prefer readable scripts over many small fragmented files.

Target:

- keep scripts understandable in a single scroll view when possible
- do not bloat scripts with comments
- comments shall be written in English

---

### Configuration Rules

All configuration MUST be stored in YAML files inside:

- system configuration in `config/`
- software package configuration in each package folder in `software/<package>/install.yaml`
  
Rules:

- No hardcoded machine-specific values
- YAML defines behaviour
- PowerShell reads configuration only
- PowerShell does NOT overwrite YAML

Typical system configuration values:

- hostname
- username
- password
- keyboard layout
- display scaling
- desktop settings
- software selection
- hardware type
- WiFi SSID and password

---

## Deployment Behaviour

### Mandatory behaviour

Deployment must always:

- continue when optional components fail
- log all actions
- report errors clearly
- remain recoverable

### Failure rules

Critical failures:

- Bootstrap failure
- deploy.ps1 failure
- software installation failure
- driver installation failure
- file copy

Optional failures:

- none

---

## Logging Rules

- One log file per deployment
- Location: logs/deploy.log
- All scripts write to same log file
- Log must include:
  - timestamp
  - script name
  - action
  - result
  - error details (if any)

---

## Error Handling

- Do NOT silently fail critical operations
- Optional failures must not stop deployment
- Always log errors
- Deployment should be resilient

---

## PowerShell Rules

- Use clear, readable code
- Avoid aliases
- Avoid overly advanced constructs
- Use Try/Catch for critical operations
- Prefer explicit logic over compact syntax
- Keep scripts understandable for non-experts
- Variables names clearly indicate their purpose
- Static values defined on top and names in capitals, defined via YAML

---

## Configuration Philosophy

Configuration is preferred over code changes.

If behaviour can be changed via YAML, it must NOT require script modification.

---

## Windows Configuration Rules

Default system settings include:

- Administrator account enabled
- Automatic login enabled
- Keyboard: Belgian AZERTY
- Secondary keyboard: US International
- Display scaling: 150%
- Desktop background: solid black (#000000)
- Wallpaper disabled
- Windows shall not share any privacy data with Microsoft

Performance must always be prioritized.

---

## Network Rules

Network connectivity is established during bootstrap:

- WiFi configuration is stored in `config/wifi.yaml`
- If `wifi.yaml` exists with valid SSID and password, bootstrap connects via WLAN
- If `wifi.yaml` does not exist, a USB-C Ethernet adapter must be connected
- DHCP is used for all network connections

---

## Software Rules

Software must be:

- modular
- optional
- explicitly enabled via configuration
- automatically installed without manual intervention (unattended installation)
- installers shall be downloaded directly from the internet or copied from the USB flash drive into the corresponding directory in `software/`
- installation order is determined by the directory name prefix (e.g. `01 vc_redist` installs before `02 DXLog`)

Initial supported software:

- N1MM Logger+
- WSJT-X
- MSHV
- DXLog

Adding new software must NOT require redesign.

---

## Driver Rules

Driver installation order:

1. Windows Update (mandatory)
2. Local drivers/ folder
3. Skip if not available

Drivers must never break deployment if missing.

### Local driver rules

- The local drivers folder contains a directory for each supported hardware type.
- The hardware type to use shall be defined in the system configuration `system.yaml` file.
- Only install the drivers for the given hardware type.
- Each driver is in its own sub directory.
- The driver sub directory name defines the order of installation: `01 driver` is installed before `05 driver`.
- Local drivers are `.exe` installers executed with silent arguments. They are installed unattended.
- Missing driver directories or missing `.exe` files are skipped with a log warning.

---

## File Deployment Rules

Files in `files/` are copied to the system.

Rules:

- Structure mirrors destination structure
- No dynamic generation unless necessary
- Use of wildcards is allowed to copy
- Recursively copy directory content if wildcards are used
- Must be configurable via YAML

---

## Restore Rules

Restore must:

- reset Windows configuration
- restore registry settings
- reinstall missing software
- restore files
- verify system consistency

Restore must NOT reinstall Windows.

---

## Performance Rules

System must remain lightweight.

Do NOT:

- install unnecessary services
- enable background agents
- install heavy management tools
- modify performance settings without justification

---

## Security Rules

- Local administrator account allowed
- No Microsoft account required
- Password must be configurable

DO NOT:

- bypass Windows activation
- circumvent licensing
- modify activation mechanisms

---

## Documentation Rules

Every script must include:

- purpose
- usage
- expected behaviour

Documentation must stay simple and practical and written in English.

---

## OpenCode Execution Rules

When implementing tasks:

1. Read AGENTS.md
2. Read PROJECT.md
3. Read ROADMAP.md
4. Implement ONLY the current task
5. Do NOT implement future phases
6. Keep changes minimal and focused
7. Avoid refactoring unrelated code

---

## Stability Rules

Do not redesign the system during implementation.

Do not introduce new architecture patterns.

Do not replace simple solutions with complex ones.

---

## Change Philosophy

If a change does not:

- simplify the system
- improve reliability
- improve clarity

then it should NOT be implemented.

---

## Success Criteria

A deployment is successful when:

- Windows is installed
- System is configured
- Software is installed
- Drivers are installed (if available)
- Configuration is applied
- System is ready for use

With minimal manual interaction.

---

## Final Rule

Always choose the simplest solution that works.
