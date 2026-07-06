# USB Boot and Unattended Installation Preparation

This document explains how to prepare the Tiny11 Windows installation USB drive and configure it to run the automated installation and orchestrator.

## 1. Create the Base Tiny11 USB Drive

First, create a basic bootable USB drive containing the Tiny11 installation files.
Follow the instructions in [hardware/usb-drive-tiny11.md](../hardware/usb-drive-tiny11.md) to download Tiny11 and flash the USB drive using Rufus.

## 2. Copy the Orchestrator Project Files

The unattended installation script is configured to look for the deployment repository directly on the USB drive.

1. Ensure the USB drive is plugged into your PC.
2. Clone or copy this entire repository to the **root** of the USB drive.
3. The directory structure on your USB drive should look like this:

   ```text
   USB_DRIVE_ROOT/
   ├── Autounattend.xml      <-- Place a copy here (see Step 3)
   ├── install/
   │   ├── Autounattend.xml  <-- Part of this repository
   │   └── bootstrap.ps1     <-- Part of this repository (Phase 3)
   ├── scripts/
   ├── config/
   ├── software/
   ├── hardware/
   └── README.md
4. Place Autounattend.xml on the USB Root

For Windows Setup to detect the unattended installation configuration, Autounattend.xml must be located at the root of the USB drive.
Copy the Autounattend.xml file from install/Autounattend.xml in your repository directly to the root of the USB drive (e.g., E:\Autounattend.xml).
