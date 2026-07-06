# Boot from Tiny11 USB

## Purpose

Guide for preparing a Tiny11 USB flash drive that installs Windows automatically using the answer file from this repository.

## Requirements

- Tiny11 ISO image (download from the official source)
- USB flash drive (8 GB or larger)
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

## Step 3: Copy Repository

1. Clone the repository to the USB flash drive:

   ```powershell
   git clone <repository-url> X:\dxpedition-orchestrator
   ```

2. Replace X: with the actual drive letter of your USB flash drive

## Step 4: Copy Installers (Optional)

If internet access will not be available during deployment:

1. Download required software installers on the preparation PC
2. Copy them into `X:\dxpedition-orchestrator\software\<package>\` on the USB drive

Each installer must be placed in its corresponding package directory.

Example:

```
software\N1MM-Logger-plus\N1MMLoggerPlus.exe
software\WSJT-X\wsjtx-installer.exe
```

## Step 5: Boot and Install

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
- Partitions the system drive automatically
- Creates the local administrator account
- Enables automatic login
- Disables Windows Defender (Tiny11 default)
- Disables privacy questions (Tiny11 default)

After installation, the system boots and the bootstrap phase begins.

## Troubleshooting

| Problem | Solution |
|---|---|
| USB not booting | Check BIOS boot order, enable legacy boot or UEFI as appropriate |
| Answer file not detected | Verify autounattend.xml is in the root of the USB drive with the correct filename |
| Installation asks questions | The answer file may not match the Tiny11 edition. Check the product key or edition settings in the answer file |