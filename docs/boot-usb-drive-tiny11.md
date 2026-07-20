# Boot USB Drive with Tiny11

## Purpose

Guide for preparing a Tiny11 USB flash drive that installs Windows automatically using the answer file from this repository.

## What does Tiny11 contain?

- Serviceable Windows 11 image
- Bypassed hardware requirements (TPM, Secure Boot, RAM)
- Removes 50+ bloatware apps including AI/Copilot/Recall
- Complete removal of Microsoft Edge WebView2 footprints (Program Files and WinSxS assemblies)
- Enhanced telemetry blocking and privacy protection
- VRAM gaming optimization
- Maintains WinSxS for updates
- Suitable for regular use
- **License**: You need a valid Windows license from Microsoft
- **Security**: These images remove Windows Defender and disable updates

## Requirements

- Tiny11 ISO image
- USB flash drive (16 GB or larger — needs space for project directory + installers)
- Windows PC with Rufus (or Mac with WinDiskWriter)
- This repository

## Step 1: Create Tiny11 USB

### Download Tiny11

The initial versions of Tiny11 were created by *NTDEV* and available on the [official Internet Archive page by NTDEV](https://archive.org/search?tab=all&query=NTDEV+tiny11&sort=-date&and%5B%5D=subject%3A%22tiny+11%22).

A more up to date version (based on the original work by *NTDEV*) is now available from [*Kelexine*](https://github.com/kelexine/tiny11-automated) at [SourceForge](https://sourceforge.net/projects/tiny-11-releases/)

Download the Windows 11 Pro .iso image file of your choice.

### Create bootable USB on Windows

#### Download Rufus

Go to [rufus.ie](https://rufus.ie) and download the latest version.

#### Create the bootable USB flash drive using Rufus

1. Open Rufus and select your USB drive.
2. Under "Boot selection", select the Tiny11 .iso you downloaded.
3. Ensure "Partition scheme" is set to GPT and "Target system" is set to UEFI (non CSM).
4. Click START. (If Rufus prompts you to remove Windows 11 hardware requirements like TPM/Secure Boot, make sure those boxes are checked).

### Create bootable USB on Mac

#### Download WinDiskWriter

Go to [GitHub WinDiskWriter](https://github.com/TechUnRestricted/WinDiskWriter) and download the latest version.

Extract / install WinDiskWriter as usual in Applications.

#### Create the bootable USB flash drive on Mac

1. Open WinDiskWriter
2. Select the Windows image iso file previously downloaded
3. Select the target USB device
4. Select FAT32
5. Press Start and confirm again to start writing to the USB flash drive

## Step 2: Copy Autounattend.xml

The answer file automates the entire Windows installation.

1. Open the USB flash drive after Rufus / WinDiskWriter finishes
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
