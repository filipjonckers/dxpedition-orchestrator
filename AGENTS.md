# AGENTS.md

# DXpedition Orchestrator

## Purpose

DXpedition Orchestrator is a lightweight Windows deployment toolkit for Tiny11 laptops.

It automatically installs, configures and prepares Windows systems using PowerShell and configuration files stored in Git.

Target environment:

- up to 8 laptops
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
3. Git is installed if needed
4. Repository is cloned or updated
5. deploy.ps1 is executed
6. System is configured
7. Drivers are installed
8. Software is installed
9. Deployment completes

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
- Git
- YAML configuration files

---

## Git Rules

- Only use the `main` branch
- No feature branches
- No release branches
- No Git workflows
- Repository is single source of truth

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
- software/ → installers or install logic
- drivers/ → driver packages
- docs/ → documentation

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
- driver mode

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
- Git failure
- deploy.ps1 failure
- software installation
- driver installation
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

Performance must always be prioritized.

---

## Software Rules

Software must be:

- modular
- optional
- explicitly enabled via configuration
- automatically installed without manual intervention (unattended installation)

Initial supported software:

- N1MM Logger+
- WSJT-X
- MSHV
- DXLog
- N1MM

Adding new software must NOT require redesign.

---

## Driver Rules

Driver installation order:

1. Windows Update (preferred)
2. Local drivers/ folder
3. Skip if not available

Drivers must never break deployment if missing.

---

## File Deployment Rules

Files in `files/` are copied to the system.

Rules:

- Structure mirrors destination structure
- No dynamic generation unless necessary
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
