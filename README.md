# Windows Update Loop Fix

> An automated wizard to fix the "Checking for Updates" loop on Windows 7 SP1

## Overview

When a fresh copy of Windows 7 is installed, the update mechanism originally included with the operating system can't interact with the new Microsoft servers, causing the update check to hang. This wizard was written specifically to fix the "Checking for Updates" loop that occurs on Windows 7 systems.

The wizard also installs KB3102810. This update addresses high CPU usage by the svchost.exe proces during updating operations.

The fix is divided into three stages:

1. Resets all Windows Update components
2. Installs the latest Windows Update Agent
3. Installs KB3020369, KB3172605 and KB3102810

## Compatibility

Compatible with **Windows 7 SP1 only**. No support will be provided for a different version.

If you are running Windows 7, make sure Service Pack 1 is installed.

## Instructions

1. Download the latest release from [here](https://github.com/aakkam22/windowsUpdateLoopFix/releases)
2. Exit any running applications
3. Double-click the wizard.exe file inside the .zip folder

###

* The **"Custom (advanced users only)"** option allows you to skip to a specific stage of the fix 

* For the best results, choose the **"Express (recommended)"** option to run through all the stages in order

The wizard will connect to the Internet to download the updates for installation. Please disconnect from the Internet when the required files have downloaded to ensure a smooth installation.

## Package Safety

Files downloaded from the Internet can sometimes trigger false anti-virus alarms. This program has been scanned with the latest anti-virus definitions and does not contain malware. 

## Help

* See [FAQ.md](https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/FAQ.md) for a list of frequently encountered problems and solutions.

* See [CHANGELOG.md](https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/CHANGELOG.md) for development history.

* For all other feedback, please [open an issue](https://github.com/aakkam22/windowsUpdateLoopFix/issues/new) on the GitHub repository. Include error codes, screen-shots, and system details.

## Terms of Use

You use this script at your own risk. While this wizard has been tested extensively, the developer assumes no responsibility for any damage.