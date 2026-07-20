# Boot from Tiny11 USB

## Purpose

Guide for preparing a Tiny11 USB flash drive that installs Windows automatically using the answer file from this repository.

## Requirements

- Tiny11 ISO image (download from the official source)
- USB flash drive (16 GB or larger — needs space for project directory + installers)
- Windows PC with Rufus (or similar tool)
- This repository

## Step 1: Prepare Tiny11 USB

Use Rufus to write the Tiny11 ISO to a USB flash drive:

1. Open Rufus
2. Select the USB drive
3. Click SELECT and choose the Tiny11 ISO
4. Keep default settings
5. Click START
6. Wait until the process completes

## Step 2: Copy Autounattend.xml

The answer file automates the entire Windows installation.

1. Open the USB flash drive after Rufus finishes
2. Copy `install/Autounattend.xml` from this repository to the root of the USB flash drive
3. Rename it to `autounattend.xml` (lowercase) on the USB drive

The file must be at the root of the USB drive.

## Step 3: Add the dxpedition-orchestrator directory

Copy the entire project directory to the USB flash drive:

```
X:\dxpedition-orchestrator\
  ├── config/
  ├── scripts/
  ├── software/
  ├── drivers/
  ├── files/
  ├── install/
  └── ...
```

Replace X: with the actual drive letter of your USB flash drive.

## Step 4: Copy or update Installers

1. Download required software installers on the preparation PC
2. Copy them into `X:\dxpedition-orchestrator\software\<package>\` on the USB drive
3. Verify the `install.yaml` for each package, adapt the software installer executable name if needed

Each installer must be placed in its corresponding package directory.

Example:

```
software\01 vc_redist\VC_redist.x64.exe
software\02 DXLog\DXLog.net-latest.msi
software\04 N1MM-Logger-plus\N1MM-Logger-FullInstaller-latest.exe
software\05 WSJT-X\wsjtx-latest-win64.exe
software\06 MSHV\MSHV_latest_Installer_32_and_64bit.exe
```

## Step 5: Configure WiFi (Optional)

If internet access is required during deployment (e.g. Windows Update drivers, software downloads):

1. Open `config/wifi.yaml` on the USB drive
2. Set the SSID and password:

```yaml
ssid: "YourNetworkName"
password: "YourPassword"
```

If `wifi.yaml` does not exist or is empty, a USB-C Ethernet adapter must be connected during deployment.

## Step 6: Boot and Install

1. Insert the USB flash drive into the target laptop
2. Boot from USB:
   - Press the boot menu key during startup (typically F2, F10, F12, DEL, or ESC)
   - Select the USB drive
3. Windows installation begins automatically
4. No input required

## What happens automatically

The answer file performs the following:

- Selects Windows edition
- Accepts the license terms
- Partitions the system drive automatically (EFI + MSR + NTFS)
- Enables Compact OS to reduce disk footprint
- Creates the local administrator account
- Enables automatic login
- Disables Windows Defender (Tiny11 default)
- Disables privacy questions (Tiny11 default)
- Disables UAC
- Disables Windows Firewall
- Sets keyboard layout to Belgian AZERTY
- Copies the deployment directory from USB to system drive
- Runs bootstrap.ps1 on first logon

After installation, the system boots and the bootstrap phase begins:

1. Bootstrap connects to WiFi (if configured)
2. Deploy starts
3. Windows is configured (display, keyboard, privacy, performance)
4. Drivers are installed (Windows Update + local drivers)
5. Software is installed (in directory name order)
6. Configuration files are copied
7. System is ready for use

## Troubleshooting

| Problem | Solution |
|---|---|
| USB not booting | Check BIOS boot order, enable legacy boot or UEFI as appropriate |
| Answer file not detected | Verify autounattend.xml is in the root of the USB drive with the correct filename |
| Installation asks questions | The answer file may not match the Tiny11 edition. Check the product key or edition settings in the answer file |
| No network during deployment | Check WiFi config in `config/wifi.yaml` or connect USB-C Ethernet adapter |
| Deployment continues after errors | Non-critical failures (e.g. drivers) are logged; check `logs/deploy.log` for details |