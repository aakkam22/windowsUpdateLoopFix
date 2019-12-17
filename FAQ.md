# FAQ

#### Don't see your problem? [Open an issue](https://github.com/aakkam22/windowsUpdateLoopFix/issues/new) on the GitHub repository.

## Stage 3 hangs when installing the updates

Depending on your configuration, the installation could take a long time to complete. If you've waited a reasonable amount of time, try these steps in order:

**Perform a clean boot**

Another process might be interfering with or blocking installation, so run the wizard in a clean boot environment. A clean boot starts Windows with only the core system services and processes running. See [this](https://support.microsoft.com/en-us/help/929135/how-to-perform-a-clean-boot-in-windows) Microsoft Support article for instructions on performing a clean boot.

**Install the System Update Readiness Tool**

The SURT was released by Microsoft in October 2014. It will check for and patch any known issues in your Windows Update data store that might be preventing other updates from installing. You can download the SURT [here](https://support.microsoft.com/en-us/help/947821/fix-windows-update-errors-by-using-the-dism-or-system-update-readiness).

## The command prompt window hangs on "Requesting administrative privileges" after a reboot

After your computer reboots, it is busy loading all of the services and startup items, and the script takes the lowest priority. Depending on your configuration, you may need to wait a minute or two to receive the UAC prompt.

## My anti-virus program is flagging and removing the download. Does it contain malware?

You can read a detailed description of how this script works and how the .exe file was created in [README.MD.](README.MD)

This package was created with official 7-Zip modules and scanned with the latest anti-virus definitions before being uploaded to GitHub. However, some anti-virus programs' heuristics may err on the side of caution and flag it as malware. Please be assured it is not malware.

## I get "Unsupported Operating System" but I am running Windows 7. 

Make sure that you have Service Pack 1 installed. You can download SP1 [here](https://www.microsoft.com/en-us/download/details.aspx?id=5842).
