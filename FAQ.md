# FAQ

#### Don't see your problem? [Open an issue](https://github.com/aakkam22/windowsUpdateLoopFix/issues/new) on the GitHub repository.

## The wizard hangs on Stage 3 when installing the updates.

Try these steps in order:

### Perform a clean boot 

Another process might be interfering with or blocking installation, so run the wizard in a clean boot environment. A clean boot starts Windows with only the core system services and processes running. See [this](https://support.microsoft.com/en-us/help/929135/how-to-perform-a-clean-boot-in-windows) Microsoft Support article for instructions on performing a clean boot.

### Temporarily disable Windows Update
Open Windows Update and change the updating settings to **"Never check for updates (not recommended)"**. Then try Stage 3 again. This change ensures that Windows Update remains "asleep" during update installation. Don't forget to re-enable Windows Update after running the fix.

### Install the System Update Readiness Tool (SURT)

The SURT was released by Microsoft in October 2014. It will check for and patch any known issues in your Windows Update data store that might be preventing other updates from installing. You can download the SURT [here](https://support.microsoft.com/en-us/help/947821/fix-windows-update-errors-by-using-the-dism-or-system-update-readiness).

## The wizard hangs on "Requesting administrative privileges" after a reboot.

After your computer reboots, it is busy loading everything back up and the wizard takes the lowest priority. Depending on your computer speed, you may need to wait a minute or two to receive the UAC prompt.

## My anti-virus program is flagging and removing the wizard. Does it contain malware?

The wizard is an unsigned file downloaded from the Internet. Please be assured that it contains no malware. However, because it is an unsigned file, some anti-virus programs will err on the side of caution and flag it as malware. 

To fix this issue, I would need to obtain a digital certificate and sign the code with it. However, this is a difficult and costly process and this project is not significant enough to warrant such a formality.

## The wizard reports "Unsupported Operating System" but I am running Windows 7. 

Make sure that you have Service Pack 1 installed. You can download SP1 [here](https://www.microsoft.com/en-us/download/details.aspx?id=5842).
