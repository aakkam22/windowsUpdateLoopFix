@echo off

REM NAME: Windows Update Loop Fix
REM VERSION: 5.0
REM BUILD DATE: 17 December 2019
REM AUTHOR: aakkam22

REM check for elevated privileges
:checkAdmin
fsutil dirty query %systemdrive% >nul
	if '%errorlevel%' NEQ '0' (
		echo Administrative privileges not detected. Now exiting...
		timeout /t 7
		exit
	) else ( goto setWindow )

REM Function to set the window properties
:setWindow
title Windows Update Loop Fix
mode con cols=80 lines=40
goto verifyOS

REM Function verifies the the OS is Windows 7 with Service Pack 1
:verifyOS
for /f "tokens=4-5 delims=[] " %%a in ('ver') do set version=%%a%%b
for %%a in (%version%) do set version=%%a
	if %version% == 6.1.7601 (
		goto mainMenu
	else
		goto invalidOS
	)

:invalidOS
echo.
echo Unsupported Operating System Detected
echo.
echo This fix only applies to Windows 7 SP1. 
echo If you are running Windows 7, please download Service Pack 1.
echo.
echo Press any key to exit.
pause>nul
exit

REM Function to print header
:printHeader
cls
echo.
echo %screen%
echo.
goto :eof

REM Main menu options
:mainMenu
cls
mode con cols=80 lines=40
echo.
echo Windows Update Loop Fix
echo Version 5.0
echo.
echo This script was written to fix the "Checking for Updates" loop that occurs on
echo Windows 7 systems.
echo.
echo Please choose an option:
echo.
echo.	+------------------------------------------------+
echo.	^|			       			 ^|
echo.	^|  [1] Express Fix (Recommended)	         ^|
echo.	^|			       			 ^|
echo.	^|  [2] Advanced Options (Advanced Users Only)    ^|
echo.	^|			       			 ^|
echo.	^|  [3] Help		        		 ^|
echo.	^|			       			 ^|
echo.	^|  [4] Go to GitHub Repository  		 ^|
echo.	^|			       			 ^|
echo.	^|			       			 ^|
echo.	^|  [5] Exit		       			 ^|
echo.	^|			       			 ^|
echo.	+------------------------------------------------+
choice /c 1234 /n
	if %errorlevel% EQU 1 set custom=false && goto termsOfUse
	if %errorlevel% EQU 2 goto chooseCustom
	if %errorlevel% EQU 3 start https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/README.md && goto :mainMenu
	if %errorlevel% EQU 4 start https://github.com/aakkam22/windowsUpdateLoopFix && goto :mainMenu
	if %errorlevel% EQU 5 exit
	
:chooseCustom
set screen=Advanced Options (Advanced Users Only)
call :printHeader
echo This script is divided into 3 stages. Use this menu to start the script at a
echo specific stage.
echo.
echo.	+---------------------------------------------------+
echo.	^|						    ^|
echo.	^|  [1] Reset all Windows Update Components	    ^|
echo.	^|						    ^|
echo.	^|  [2] Install the latest Windows Update Agent      ^|
echo.	^|						    ^|
echo.	^|  [3] Install KB3020369 and KB3172605              ^|
echo.	^|						    ^|
echo.	^|						    ^|
echo.	^|  [4] Back				  	    ^|
echo.	^|						    ^|
echo.	+---------------------------------------------------+
choice /c 1234 /n
	if %errorlevel% EQU 1 set custom=false && goto termsOfUse
	if %errorlevel% EQU 2 set custom=2 && goto termsOfUse
	if %errorlevel% EQU 3 set custom=3 && goto termsOfUse
	if %errorlevel% EQU 4 goto mainMenu

:termsOfUse
set screen=Important Information
call :printHeader
echo This script will modify sensitive system files. 
echo Please ensure that your files are backed up before continuing.
echo The author of this script is not responsible for data loss.
echo.
echo An Internet connection is required to download the updates.
echo.
echo Press [A] to agree or [E] to exit.
choice /c AE /n
	if %errorlevel% EQU 1 goto determineArc
	if %errorlevel% EQU 2 exit

REM determine whether the system is 32 or 64-bit
:determineArc
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set arc=32BIT || set arc=64BIT >nul 2>&1
	if %arc%==32BIT goto download32
	if %arc%==64BIT goto download64

REM function to clear the BITS queue and create the directories to store the updates to download
:initializeDownload
echo Initializing...

REM stop the Windows Update and BITS service so we can work with their file stores
net stop bits >nul 2>&1
net stop wuauserv >nul 2>&1

REM flush the DNS cache
ipconfig /flushdns >nul 2>&1

REM rename the old bits datastores, this clears any stuck jobs
ren "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr0.dat" qmgr0.dat.old >nul 2>&1
ren "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr1.dat" qmgr1.dat.old >nul 2>&1

REM restart the BITS service, leave Windows Update off so it doesn't interfere with standalone installations
net start bits >nul 2>&1

REM remove the packages directory if it's there and recreate it
rmdir %systemdrive%\packages /s /q >nul 2>&1
md %systemdrive%\packages >nul 2>&1

REM this variable will be used to detect download errors
set downErr=false
goto :eof	
	
REM bits transfers for 32-bit systems
:download32
set screen=Downloading Updates
call :printHeader
echo Please wait while the updates are downloaded to the installation folders.
echo This could take several minutes depending on your connection speed.
echo.
echo Destination Directory: "%systemdrive%\packages"
echo.
echo.
call :initializeDownload
echo Done!
echo.

echo Downloading Update for Windows 7 (KB3020369)...
bitsadmin /transfer kb3020369 https://download.microsoft.com/download/C/0/8/C0823F43-BFE9-4147-9B0A-35769CBBE6B0/Windows6.1-KB3020369-x86.msu "%systemdrive%\packages\3020369.msu" >nul 2>&1
	if %errorlevel% EQU 0 echo Success!
	if %errorlevel% NEQ 0 set downErr=true && echo Download failed.
echo.

echo Downloading Update for Windows 7 (KB3172605)...
bitsadmin /transfer kb3172605 https://download.microsoft.com/download/C/D/5/CD5DE7B2-E857-4BD4-AA9C-6B30C3E1735A/Windows6.1-KB3172605-x86.msu "%systemdrive%\packages\3172605.msu" >nul 2>&1
	if %errorlevel% EQU 0 echo Success!
	if %errorlevel% NEQ 0 set downErr=true && echo Download failed.
echo.

echo Downloading Windows Update Agent v7.6...
bitsadmin /transfer wua http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/windowsupdateagent-7.6-x86.exe "%systemdrive%\packages\wua.exe" >nul
	if %errorlevel% EQU 0 echo Success!
	if %errorlevel% NEQ 0 set downErr=true && echo Download failed.
echo.

echo Copying script files...
xcopy /v /y updates.cmd %systemdrive%\packages >nul 2>&1
xcopy /v /y cleanup.cmd %systemdrive%\packages >nul 2>&1

REM take a count of the files in the packages directory to make sure all files are present
set cnt=0
for %%A in (%systemdrive%\packages\*) do set /a cnt+=1
	if %cnt% NEQ 5 set downErr=true
echo.

if %downErr%==true goto downFail
if %downErr%==false goto downSuccess

REM bits transfers for 64-bit systems
:download64
set screen=Downloading Updates
call :printHeader
echo Please wait while the updates are downloaded to the installation folder.
echo This could take several minutes depending on your connection speed.
echo.
echo Destination Directory: "%systemdrive%\packages"
echo.
echo.
call :initializeDownload
echo Done!
echo.

echo Downloading Update for Windows 7 for x64-based Systems (KB3020369)...
bitsadmin /transfer kb3020369 https://download.microsoft.com/download/5/D/0/5D0821EB-A92D-4CA2-9020-EC41D56B074F/Windows6.1-KB3020369-x64.msu "%systemdrive%\packages\3020369.msu" >nul 2>&1
	if %errorlevel% EQU 0 echo Success!
	if %errorlevel% NEQ 0 set downErr=true && echo Download failed.
echo.

echo Downloading Update for Windows 7 for x64-based Systems (KB3172605)...
bitsadmin /transfer kb3172605 https://download.microsoft.com/download/5/6/0/560504D4-F91A-4DEB-867F-C713F7821374/Windows6.1-KB3172605-x64.msu "%systemdrive%\packages\3172605.msu" >nul 2>&1
	if %errorlevel% EQU 0 echo Success!
	if %errorlevel% NEQ 0 set downErr=true && echo Download failed.
echo.

echo Downloading Windows Update Agent v7.6...
bitsadmin /transfer wua http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/windowsupdateagent-7.6-x64.exe "%systemdrive%\packages\wua.exe" >nul
	if %errorlevel% EQU 0 echo Success!
	if %errorlevel% NEQ 0 set downErr=true && echo Download failed.
echo.

echo Copying script files...
xcopy /v /y updates.cmd %systemdrive%\packages >nul 2>&1
xcopy /v /y cleanup.cmd %systemdrive%\packages >nul 2>&1

REM take a count of the files in the packages directory to make sure all files are present
set cnt=0
for %%A in (%systemdrive%\packages\*) do set /a cnt+=1
	if %cnt% NEQ 5 set downErr=true
echo.

if %downErr%==true goto downFail
if %downErr%==false goto downSuccess

REM if the download failed, exit the script
:downFail
echo One or more of the required files could not be downloaded or copied.
echo Please contact the developer for help.
echo.
echo Press any key to exit.
pause>nul
exit

:downSuccess
timeout /t 2 /nobreak>nul
echo All files were downloaded successfully.
timeout /t 7
goto ready

REM prompt the user to begin the fix process
:ready
set screen=Ready to Continue
call :printHeader
if %custom% NEQ false echo (Advanced Option Selected - Will begin at Stage %custom%) && echo.
echo The script is now ready to run. Your computer will restart several times
echo during this process.
echo.
echo NOTE: It is strongly recommended to disconnect from the Internet now. 
echo This prevents Windows Update from attempting to connect while it is 
echo being serviced.
echo.
echo Save your work, close any open programs, and press any key to continue.
pause>nul
if %custom% EQU false goto reset
if %custom% EQU 2 goto wuaInstall
if %custom% EQU 3 (
	call %systemdrive%\packages\updates.cmd
	exit
)

REM reset Windows Update components
:reset
set screen=Stage 1 of 3 (Resetting Windows Update Components)
call :printHeader
echo Please wait while the following actions are run:
echo.
echo.

echo.-^> Stopping Windows Update, BITS, and Cryptographic Services...
net stop bits /y >nul 2>&1
net stop wuauserv /y >nul 2>&1
net stop appidsvc /y >nul 2>&1
net stop cryptsvc /y >nul 2>&1
echo.

echo.-^> Deleting qmgr*.dat files...
Del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat">nul 2>&1
echo.

echo.-^> Deleting SoftwareDistribution folders...
cd /d %SYSTEMROOT%>nul 2>&1
	if exist "%SYSTEMROOT%\winsxs\pending.xml.bak" (
		del /s /q /f "%SYSTEMROOT%\winsxs\pending.xml.bak">nul 2>&1
	)
	if exist "%SYSTEMROOT%\SoftwareDistribution.bak" (
		rmdir /s /q "%SYSTEMROOT%\SoftwareDistribution.bak">nul 2>&1
	)
	if exist "%SYSTEMROOT%\system32\Catroot2.bak" (
		rmdir /s /q "%SYSTEMROOT%\system32\Catroot2.bak">nul 2>&1
	)
	if exist "%SYSTEMROOT%\WindowsUpdate.log.bak" (
		del /s /q /f "%SYSTEMROOT%\WindowsUpdate.log.bak">nul 2>&1
	)
	if exist "%SYSTEMROOT%\winsxs\pending.xml" (
		takeown /f "%SYSTEMROOT%\winsxs\pending.xml">nul 2>&1
		attrib -r -s -h /s /d "%SYSTEMROOT%\winsxs\pending.xml">nul 2>&1
		ren "%SYSTEMROOT%\winsxs\pending.xml" pending.xml.bak>nul 2>&1
	)
	if exist "%SYSTEMROOT%\SoftwareDistribution" (
		attrib -r -s -h /s /d "%SYSTEMROOT%\SoftwareDistribution">nul 2>&1
		ren "%SYSTEMROOT%\SoftwareDistribution" SoftwareDistribution.bak>nul 2>&1
	)
	if exist "%SYSTEMROOT%\system32\Catroot2" (
		attrib -r -s -h /s /d "%SYSTEMROOT%\system32\Catroot2">nul 2>&1
		ren "%SYSTEMROOT%\system32\Catroot2" Catroot2.bak>nul 2>&1
	)
	if exist "%SYSTEMROOT%\WindowsUpdate.log" (
		attrib -r -s -h /s /d "%SYSTEMROOT%\WindowsUpdate.log">nul 2>&1
		ren "%SYSTEMROOT%\WindowsUpdate.log" WindowsUpdate.log.bak>nul 2>&1
	)
echo.	

echo.-^> Resetting BITS and WUAUSERV to default security descriptors...
sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)>nul 2>&1
sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)>nul 2>&1
echo.

echo.-^> Reregistering BITS and Windows Update files...
cd /d %WINDIR%\system32
regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll
regsvr32.exe /s shdocvw.dll
regsvr32.exe /s browseui.dll
regsvr32.exe /s jscript.dll
regsvr32.exe /s vbscript.dll
regsvr32.exe /s scrrun.dll
regsvr32.exe /s msxml.dll
regsvr32.exe /s msxml3.dll
regsvr32.exe /s msxml6.dll
regsvr32.exe /s actxprxy.dll
regsvr32.exe /s softpub.dll
regsvr32.exe /s wintrust.dll
regsvr32.exe /s dssenh.dll
regsvr32.exe /s rsaenh.dll
regsvr32.exe /s gpkcsp.dll
regsvr32.exe /s sccbase.dll
regsvr32.exe /s slbcsp.dll
regsvr32.exe /s cryptdlg.dll
regsvr32.exe /s oleaut32.dll
regsvr32.exe /s ole32.dll
regsvr32.exe /s shell32.dll
regsvr32.exe /s initpki.dll
regsvr32.exe /s wuapi.dll
regsvr32.exe /s wuaueng.dll
regsvr32.exe /s wuaueng1.dll
regsvr32.exe /s wucltui.dll
regsvr32.exe /s wups.dll
regsvr32.exe /s wups2.dll
regsvr32.exe /s wuweb.dll
regsvr32.exe /s qmgr.dll
regsvr32.exe /s qmgrprxy.dll
regsvr32.exe /s wucltux.dll
regsvr32.exe /s muweb.dll
regsvr32.exe /s wuwebv.dll
echo.

echo.-^> Resetting Winsock...
netsh winsock reset >nul 2>&1
echo.

echo.-^> Resetting WinHTTP proxy...
netsh winhttp reset proxy >nul 2>&1
echo.


echo.-^> Configuring service startup types...
sc config wuauserv start= auto  >nul 2>&1
sc config bits start= auto  >nul 2>&1
sc config DcomLaunch start= auto  >nul 2>&1
sc config appidsvc start= auto  >nul 2>&1
sc config cryptsvc start=auto >nul 2>&1
echo. 

echo.-^> Restarting services...
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
net start appidsvc >nul 2>&1
net start cryptsvc >nul 2>&1
net start DcomLaunch >nul 2>&1

echo.
timeout /t 7
goto wuaInstall

REM install Windows Update Agent
:wuaInstall
set screen=Stage 2 of 3 (Installing Windows Update Agent)
call :printHeader
echo Please wait while the Windows Update Agent is installed. 
echo This could take several minutes to complete.
call %systemdrive%\packages\wua.exe /wuforce /quiet /norestart
echo.
	IF %errorlevel%==1609 IF NOT %errorlevel%==0 (
	goto corrupt
	)
	IF %errorlevel%==3010 IF NOT %errorlevel%==0 (
	goto success
	)
	IF %errorlevel%==0 (
	goto success
	)
	IF %errorlevel%==2359302 IF NOT %errorlevel%==0 (
	goto alreadyInstalled
	)
	IF NOT %errorlevel%==0 IF NOT %errorlevel%==2359302 (
	goto installFail
	)	

REM error codes
:corrupt
echo The package is corrupt or missing.
echo.
echo Press any key to continue.
pause>nul
goto restart

:success
echo Success!
echo.
timeout /t 7
goto restart

:alreadyInstalled
echo The latest agent is already installed.
echo.
timeout /t 7
goto restart

:installFail
echo The agent could not be installed. The error code was %errorlevel%.
echo.
echo Press any key to continue.
pause>nul
goto restart

REM set the RunOnce registry key to execute the updates.cmd script, then restart the computer
:restart
set screen=Restart Computer
call :printHeader
echo Your computer needs to restart to continue. 
echo The script will continue after you log back on.
echo.
timeout /t 7
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce /v updatesinstall /t REG_EXPAND_SZ /d %systemdrive%\packages\updates.cmd >nul 2>&1
shutdown -r -t 0
