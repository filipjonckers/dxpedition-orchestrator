# PROJECT.md

# DXpedition Orchestrator

## Project Overview

DXpedition Orchestrator is a lightweight deployment toolkit for automatically installing, configuring and maintaining Windows Tiny11 laptops for DXpedition usage.

The project is intended for a medium DXpedition environment consisting of approximately eight to ten laptops.

The primary objective is to minimize manual work while keeping the solution simple, maintainable and reliable.

The project must remain Windows-native and should not require Linux or enterprise deployment infrastructure.

---

## Project Goals

The deployment process should:

- Install Windows automatically.
- Configure Windows automatically.
- Install required software automatically.
- Copy required configuration files automatically.
- Apply Windows settings automatically.
- Install drivers when available.
- Produce a laptop that is immediately ready for use.

The deployment should require as little user interaction as possible.

---

## Scope

The project includes:

- Tiny11 installation
- Windows configuration
- Software installation
- Driver installation
- Configuration management
- Restore functionality
- Logging
- Documentation

The project does not include:

- Enterprise deployment
- Domain management
- Active Directory
- Microsoft Intune
- MDT
- SCCM
- Linux infrastructure

---

## Target Environment

Hardware:

- Approximately eight to ten notebooks.
- Notebook manufacturer is unknown.
- Network connection via WiFi or USB-C Ethernet adapter.
- Network configuration uses DHCP.

---

## Deployment Workflow

The complete deployment process consists of the following stages:

1. Boot from Tiny11 installation media.
2. Windows installation starts automatically.
3. Windows creates the predefined administrator account.
4. Automatic logon occurs.
5. Bootstrap script executes.
6. WiFi connection is established if configured.
7. Deployment script executes.
8. Windows configuration is applied (including privacy settings).
9. Drivers are installed (Windows Update + local drivers).
10. Software is installed.
11. Configuration files are copied.
12. Deployment finishes.

---

## Functional Requirements

The deployment must support the following functionality.

### Windows Installation

- Automatically install Tiny11.
- Automatically partition the system drive.
- Automatically create the local administrator account.
- Automatically configure automatic logon.
- No Microsoft account should be required.

---

### Bootstrap

- Prepare Windows for deployment.
- Connect to WiFi if configured in `config/wifi.yaml`.
- Start the deployment process.
- Create deployment logs.

---

### Configuration

Configuration should be stored outside the scripts whenever possible.

Configuration includes:

- computer name
- display settings
- keyboard settings
- software selection
- hardware type
- WiFi SSID and password

---

### Windows Configuration

The deployment must support configuring Windows settings.

Initially this includes:

- Display scaling: 150%
- Desktop background: Solid black RGB: #000000
- Wallpaper: Disabled
- Keyboard: Belgian AZERTY
- Secondary keyboard: US International
- Language selector visible in the taskbar.
- Privacy: telemetry off, Cortana disabled, advertising ID off
- Explorer settings should be configurable.

Additional settings may be added later.

---

### Software

Initially the deployment should support:

- N1MM Logger+
- WSJT-X
- MSHV
- DXLog
- Visual C++ Redistributable

Installation order is determined by the directory name prefix (e.g. `01 vc_redist` installs before `02 DXLog`).

Future software should be easy to add without redesigning the project.

---

### Drivers

Driver installation must be optional.

Installation order:

1. Windows Update (mandatory)
2. Local driver packages from `drivers/<hardware_type>/` directory
3. Skip if nothing is available

Local drivers are `.exe` installers executed in numbered subdirectory order.

The deployment should not fail because drivers are unavailable.

---

### File Management

Configuration files should be copied automatically.

Examples include:

- application configuration
- templates
- radio configuration
- desktop shortcuts
- future project files

The exact file set should be configurable.

---

### Logging

The deployment should generate one deployment log.

The log should contain:

- date
- time
- executed script
- performed action
- result
- errors

The log should simplify troubleshooting.

---

### Restore

A restore operation should return the notebook to the standard project configuration.

Restore should include:

- Windows settings
- Registry settings
- Configuration files
- Software verification
- Missing software installation

Restore should not require reinstalling Windows.

---

## Non Functional Requirements

The project must remain:

- Simple
- Readable
- Reliable
- Maintainable
- Repeatable
- Fast
- Easy to modify
- Easy to troubleshoot

---

## Performance Requirements

- Performance has priority.
- The deployment should not introduce unnecessary software.
- The deployment should not enable unnecessary Windows components.
- The deployment should keep Tiny11 lightweight.

---

## Maintainability

- Future modifications should normally require changing configuration files rather than PowerShell scripts.
- Adding software should be straightforward.
- Updating software should be straightforward.
- Changing Windows settings should be straightforward.

---

## Error Handling

- Deployment should continue whenever possible.
- Critical failures should stop deployment.
- Optional failures should be logged and skipped.
- Errors should always be written to the deployment log.

---

## Security

- The project uses a local administrator account.
- No Microsoft account is required.
- Passwords should be configurable.
- The project must never implement or document methods to bypass Windows licensing or activation.
- Only legitimate Windows activation methods are supported.

---

## Documentation

Every important component must be documented.

Documentation should focus on:

- purpose
- configuration
- usage
- troubleshooting

Future maintenance should not depend on remembering implementation details.

---

## Success Criteria

The project is considered complete when a new notebook can be prepared using the following workflow:

1. Create Tiny11 installation USB.
2. Boot the notebook.
3. Wait for automatic Windows installation.
4. Wait for deployment completion.
5. Verify that:
   1. Windows is configured.
   2. Software is installed.
   3. Drivers are installed when available.
   4. Configuration files are copied.
6. The notebook is immediately ready for use.

---

## Future Expansion

Future improvements may include:

- Additional software.
- Additional Windows settings.
- Additional configuration files.
- Support for additional notebook models.
- Additional restore options.
- These additions should not require redesigning the project architecture.

---

## Project Philosophy

- Expedition Orchestrator is intentionally simple.
- The project is not intended to become a general-purpose deployment framework.
- The primary objective is to automate repetitive work while remaining easy to understand and easy to maintain.
- Whenever multiple solutions exist, the simplest solution that satisfies the requirements should be preferred.