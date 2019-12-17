# Windows Update Loop Fix

> An automated script to fix the "Checking for Updates" loop on Windows 7 SP1  

## Overview

After installing a fresh copy of Windows 7, Windows Update will hang when trying to check for updates. This problem occurs because a fresh copy of Windows 7 doesn't have the required updates to interface with Microsoft's servers. The fix is to download and install the following updates:

- April 2015 servicing stack update for Windows 7 and Windows Server 2008 R2 (KB3020369)
- July 2016 update rollup for Windows 7 SP1 and Windows Server 2008 R2 SP1 (KB3172605)
- The latest Windows Update Agent for Windows 7 (v7.6.7600.256)

This script was written to automate the process. It is divided into three stages:

1. Downloads the updates and resets all Windows Update components
2. Installs the latest Windows Update Agent
3. Installs KB3020369 and KB3172605

You can download and install the updates yourself, but running the script ensures that any previous Windows Update issues are cleared out before the updates are applied, and that the packages are installed in the correct order.

## Compatibility

To install these updates or run this script, you should have Windows 7 with Service Pack 1 installed.

## Instructions

1. Download the latest release from [here](https://github.com/aakkam22/windowsUpdateLoopFix/releases)
2. Exit any running applications
3. Double-click the UpdateFix.exe file and follow the instructions

###

* The **"Custom (Advanced Users Only)"** option allows you to skip to a specific stage of the fix 

* For the best results, choose **"Express Fix (Recommended)"** to run through all the stages in order

An Internet Connection is required to download the updates, however, it is recommended to disconnect from the Internet once the updates have been downloaded. Doing so prevents Windows Update from attempting to connect while it is being serviced.

## Package Safety

This script is comprised of three (3) individual batch files. The batch files were archived into .7z format and then the archive was used to create a 7-Zip Self-Extracting Archive using the official modules provided by Igor Pavlov. The .exe file was scanned with Windows Defender using the latest definitions available at the time of upload to GitHub.

## How The Script Works

When it is double-clicked, the self-extracting .exe file extracts three batch files to the Windows TEMP directory:

- master.cmd
- updates.cmd
- cleanup.cmd

As its name suggests, "master.cmd" is the main batch file. It:

1. Downloads the updates from Microsoft and stores them in C:\packages
2. Copies "updates.cmd" and "cleanup.cmd" to C:\packages
3. Resets Windows Update Components
4. Installs the Windows Update Agent
5. Sets the RunOnce registry key to run the next file, "updates.cmd" after the restart

After the restart, updates.cmd unpacks the .msu files for KB3020369 and KB3172605 and installs them using DISM. A log file is created at C:\install.log. It also sets the RunOnce registry key to run the final file, "cleanup.cmd".

After the final restart, "cleanup.cmd" deletes the files in the C:\packages folder, provides the user a summary of the operations, and then deletes itself.

## Help

* With the sunset of Windows 7, version 5.0 is likely the last version, unless a bug needs to be fixed.

* See [FAQ.md](https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/FAQ.md) for a list of frequently encountered problems and solutions.

* See [CHANGELOG.md](https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/CHANGELOG.md) for development history.

* For all other feedback, please [open an issue](https://github.com/aakkam22/windowsUpdateLoopFix/issues/new) on the GitHub repository. Include error codes, screen-shots, and system details.

## Terms of Use

This script will modify sensitive system files. Please ensure that your files are backed up before running this script. This script has been tested extensively. The author is not responsible for any data loss. 
