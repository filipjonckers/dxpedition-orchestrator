# USB Drive with Tiny11

This document describes the preparation steps to build a USB drive containing Tiny11 Windows install image.

## What does a Tiny 11 image contain?

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

## Create the Tiny11 Installation USB

You will need a second Windows PC or Mac and an 8GB+ USB flash drive to create the installation media.

### Download Tiny11

The initial versions of Tiny11 were created by *NTDEV* and available on the [official Internet Archive page by NTDEV](https://archive.org/search?tab=all&query=NTDEV+tiny11&sort=-date&and%5B%5D=subject%3A%22tiny+11%22).

A more up to date version (based on the original work by *NTDEV*) is now available from [*Kelexine*](https://github.com/kelexine/tiny11-automated) at [SourceForge](https://sourceforge.net/projects/tiny-11-releases/)

Download the Windows 11 Pro .iso image file of your choice.

### Create bootable USB flash drive on Windows

#### Download Rufus

Go to [rufus.ie](https://rufus.ie) and download the latest version.

#### Create the bootable USB flash drive using Rufus

1. Open Rufus and select your USB drive.
2. Under "Boot selection", select the Tiny11 .iso you downloaded.
3. Ensure "Partition scheme" is set to GPT and "Target system" is set to UEFI (non CSM).
4. Click START. (If Rufus prompts you to remove Windows 11 hardware requirements like TPM/Secure Boot, make sure those boxes are checked).

You have now a baseline usb drive containing a Tiny11 Windows version.

### Create bootable USB flash drive on Mac

#### Download WinDiskWriter

Go to [GitHub WinDiskWriter](https://github.com/TechUnRestricted/WinDiskWriter) and download the latest version.

Extract / install WinDiskWriter as usual in Applications.

#### Create the bootable USB flash drive on Mac

1. Open WinDiskWriter
2. Select the Windows image iso file previously downloaded
3. Select the target USB device
4. Select FAT32
5. Press Start and confirm again to start writing to the USB flash drive
