# USB Drive with Tiny11

This document describes the preparation steps to build a USB drive containing Tiny11 Windows install image.

## Create the Tiny11 Installation USB

You will need a second Windows PC or Mac and an 8GB+ USB flash drive to create the installation media.

### Download Tiny11

Go to the [official Internet Archive page by NTDEV](https://archive.org/search?tab=all&query=NTDEV+tiny11&sort=-date&and%5B%5D=subject%3A%22tiny+11%22) (the creator of Tiny11) and download the latest version of Tiny11 on [Archive.org](https://archive.org).

Download the Windows 11 Pro .iso image file.

### Download Rufus

Go to [rufus.ie](https://rufus.ie) and download the latest version.

### Flash the USB

1. Open Rufus and select your USB drive.
2. Under "Boot selection", select the Tiny11 .iso you downloaded.
3. Ensure "Partition scheme" is set to GPT and "Target system" is set to UEFI (non CSM).
4. Click START. (If Rufus prompts you to remove Windows 11 hardware requirements like TPM/Secure Boot, make sure those boxes are checked).

You have now a baseline usb drive containing a Tiny11 Windows version.
