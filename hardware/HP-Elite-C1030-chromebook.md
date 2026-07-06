# HP Elite C1030 ChromeBook

Installing Windows—even a stripped-down version like Tiny11—on an HP Elite c1030 Chromebook (board name: JINLON, Intel Comet Lake) is an involved process. Chromebooks are not designed to run Windows natively, so you must physically disable the device's write protection, replace the Google firmware with custom UEFI firmware, and manually install custom drivers.

## Caveats

- ***Wiping Data:*** This process will completely erase ChromeOS and all local files. Back up your data.
- ***Audio Drivers:*** While most things (Wi-Fi, Bluetooth, Touchpad) will work with custom drivers, Intel Comet Lake audio (speakers/headphone jack) requires custom SOF/AVS drivers developed by the Chrultrabook project. These specific audio drivers currently cost ~$10 via CoolStar's Patreon/Portal. Bluetooth audio and USB audio will work for free.
- ***Voided Warranty:*** Opening your device and flashing firmware will void your warranty.

## Enable Developer Mode & Disable Write Protect (WP)

Your HP Elite c1030 uses a CR50 security chip. To install custom firmware, you must bypass the hardware write protection. The easiest way for this model is the "Battery Disconnect" method.

1. **Enter Recovery Mode:** With the Chromebook powered off, hold Esc + Refresh (F3) and press the Power button.
2. **Enable Developer Mode:** When the "ChromeOS is missing or damaged" screen appears, press Ctrl + D. Press Enter to confirm turning OS verification off. The device will reboot and wipe itself (takes about 5 minutes).
3. **Boot to OS:** When it finishes, you will see a scary "OS verification is OFF" screen. Press Ctrl + D to bypass it and boot into ChromeOS. Do not log in; just connect to Wi-Fi at the welcome screen.

### Disable Hardware Write Protect

1. Power off the Chromebook completely and unplug it from the wall.
2. Turn the laptop over and carefully unscrew and remove the bottom cover.
3. Locate the battery and disconnect the battery cable from the motherboard.
4. Leave the bottom cover off (or rest it on top gently) and plug a 45W/65W HP USB-C charger directly into the laptop.
5. Turn the laptop on using only AC wall power.

(Note: Booting without the battery temporarily disables the CR50 write protection).

## Flash MrChromebox UEFI Firmware

With WP disabled and Developer Mode on, you can now overwrite the BIOS:

1. On the ChromeOS welcome screen, press Ctrl + Alt + F2 (the Right Arrow key on the top row). This opens a black terminal screen.
2. Type chronos and press Enter to log in.
3. Run the MrChromebox Firmware Utility Script by typing the following command exactly as written (Note: -LO contains a capital "O", not a zero):

```bash
cd; curl -LO mrchromebox.tech/firmware-util.sh && sudo bash firmware-util.sh
```

4. A menu will appear. Type 2 and press Enter to select Install/Update UEFI (Full ROM) Firmware.
5. Type Y to confirm you understand the risks.
6. Type U to backup your stock firmware to a USB drive (highly recommended in case you ever want to revert to ChromeOS).
7. Once the firmware is flashed successfully, a green success message will appear. Power off the Chromebook.
8. Unplug the wall charger, reconnect your internal battery cable, and screw the bottom cover back on. Your Chromebook is now essentially a standard PC.

## Install Tiny11

1. Plug your Tiny11 USB drive into the Chromebook.
2. Turn the Chromebook on. It will now boot to the MrChromebox "Coreboot" rabbit logo.
3. Press Esc to open the boot menu and select your USB drive.
4. The Windows installer will load. Because this is Tiny11, you may not have a working touchpad yet—you might need to plug in a basic USB mouse.
5. When asked where to install Windows, delete every single partition on the drive until you only have one block of "Unallocated Space".
6. Select the Unallocated Space and click Next. Tiny11 will install and reboot.

## Install Custom Windows Drivers

Standard Windows updates will not fix your touchpad or audio. You must install drivers specifically reverse-engineered for Chromebooks.

1. Boot into Tiny11 and connect to Wi-Fi.
2. Open your browser and navigate to the Chrultrabook driver page: coolstar.org/chromebook/windows-install.html
3. Select your device generation (Intel Comet Lake) from the list.
4. Download and install the custom drivers in this exact order:
  1. Keyboard mapping utility (fixes your top row Chrome keys to act as F-keys/brightness/volume)
  2. I2C / Touchpad drivers (this will make your trackpad work)
5. Restart your device.

For Audio: As mentioned, Intel Comet Lake onboard audio requires the custom SOF/AVS driver package. You will need to visit the link on CoolStar's site, pay the $10 Patreon pledge to access the driver portal, and download the Comet Lake audio package. Alternatively, use Bluetooth headphones or a USB-C audio dongle, which will work natively via Windows.

**Decision:** We will not use commercial drivers for this project.  We will use Bluetooth headphones or a USB-C audio dongle.

## Configuring the Top Row (Media vs. F-Keys)

By default, the custom UEFI firmware treats the ChromeOS top row exactly like a standard PC's F1–F10 keys.
The Chrultrabook Keyboard Utility you installed earlier intercepts these and turns them back into media keys (brightness, volume, refresh, etc.).

How to toggle and control the top row:

1. Check your Windows System Tray (the bottom-right corner of the taskbar, near the clock).
2. Look for the Chromebook Keyboard Utility icon (it often looks like a small keyboard).
3. Right-click the icon to access its settings. Here, you can toggle between two modes:
4. Media Mode: The keys act like a Chromebook (Volume, Brightness, Refresh, etc.). To use an F-key (e.g., F5 to refresh a webpage), you must hold the Search key + the corresponding top-row key.
5. Function (F-Key) Mode: The keys act strictly as F1-F10. To use the media controls, you must hold the Search key + the top-row key.

Tip: If you don't see the utility in the system tray, press Win + R, type shell:startup, and ensure the shortcut for the Keyboard Utility is in that folder so it runs every time Windows boots.
