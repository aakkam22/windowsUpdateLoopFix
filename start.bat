::=============================
::NAME: Windows Update Loop Fix
::VERSION: 4.1.2
::AUTHOR: aakkam22
::=============================


::===========
::CHECK ADMIN
::===========

@echo off

:checkAdmin
fsutil dirty query %systemdrive% >nul
	if '%errorlevel%' NEQ '0' (
		echo Administrative privileges not detected. Now exiting...
		timeout /t 6
		exit
	) else ( goto gotAdmin )

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"

call :mode
goto getValues


::=====================
::SET WINDOW PROPERTIES
::=====================
	
:mode
echo off
title Windows Update Loop Fix
mode con cols=82 lines=43
goto :eof


::=============
::PRINT HEADING
::=============

:print
cls
echo.
echo.Windows Update Loop Fix v4.1.2
echo ------------------------------
echo.
goto :eof
	
	
::=========================
::LOAD SYSTEM AND OS VALUES
::=========================
	
:getValues
	for /f "tokens=4-5 delims=[] " %%a in ('ver') do set version=%%a%%b
	for %%a in (%version%) do set version=%%a
	if %version% EQU 5.1.2600 (
		:: Name: "Microsoft Windows XP"
		set name=Microsoft Windows XP
		:: Family: Windows 5
		set family=5
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 5.2.3790 (
		:: Name: "Microsoft Windows XP Professional x64 Edition"
		set name=Microsoft Windows XP Professional x64 Edition
		:: Family: Windows 5
		set family=5
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 6.0.6000 (
		:: Name: "Microsoft Windows Vista"
		set name=Microsoft Windows Vista
		:: Family: Windows 6
		set family=6
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 6.0.6001 (
		:: Name: "Microsoft Windows Vista SP1"
		set name=Microsoft Windows Vista SP1
		:: Family: Windows 6
		set family=6
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 6.0.6002 (
		:: Name: "Microsoft Windows Vista SP2"
		set name=Microsoft Windows Vista SP2
		:: Family: Windows 6
		set family=6
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 6.1.7600 (
		:: Name: "Microsoft Windows 7"
		set name=Microsoft Windows 7
		:: Family: Windows 7
		set family=7
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 6.1.7601 (
		:: Name: "Microsoft Windows 7 SP1"
		set name=Microsoft Windows 7 SP1
		:: Family: Windows 7
		set family=7
		:: Compatibility: Yes
		set allow=Yes
	) else if %version% EQU 6.2.9200 (
		:: Name: "Microsoft Windows 8"
		set name=Microsoft Windows 8
		:: Family: Windows 8
		set family=8
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 6.3.9200 (
		:: Name: "Microsoft Windows 8.1"
		set name=Microsoft Windows 8.1
		:: Family: Windows 8
		set family=8
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 6.3.9600 (
		:: Name: "Microsoft Windows 8.1"
		set name=Microsoft Windows 8.1
		:: Family: Windows 8
		set family=8
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 10.0.10240 (
		:: Name: "Microsoft Windows 10 Threshold 1"
		set name=Microsoft Windows 10 Threshold 1
		:: Family: Windows 10
		set family=10
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 10.0.10586 (
		:: Name: "Microsoft Windows 10 Threshold 2"
		set name=Microsoft Windows 10 Threshold 2
		:: Family: Windows 10
		set family=10
		:: Compatibility: No
		set allow=No
	) else if %version% EQU 10.0.14393 (
		:: Name: "Microsoft Windows 10 Redstone 1"
		set name=Microsoft Windows 10 Redstone 1
		:: Family: Windows 10
		set family=10
		:: Compatibility: No
		set allow=Yes
	) else if %version% EQU 10.0.15063 (
		:: Name: "Microsoft Windows 10 Redstone 2"
		set name=Microsoft Windows 10 Redstone 2
		:: Family: Windows 10
		set family=10
		:: Compatibility: No
		set allow=No
	) else (
		:: Name: "Unknown"
		set name=Unknown
		:: Compatibility: No
		set allow=No
	)
	if %allow% EQU Yes goto welcome
	if %allow% NEQ Yes goto badOS


::==============
::UNSUPPORTED OS
::==============
	
:badOS
call :print
echo Unsupported Operating System
echo.
echo.	This fix is compatible with Windows 7 SP1 only.
echo.	If you are running Windows 7, make sure Service Pack 1 is installed.
echo.
echo.
echo Press any key to exit. 
pause>nul
exit


::=======	
::WELCOME
::=======

:welcome
set nocustom=0
call :print
echo Welcome
echo.	
echo.	This wizard will help you fix the "Checking for Updates" loop
echo.	that occurs on Windows 7 systems.
echo.
echo.
echo.	What would you like to do?
echo.
echo.
echo.	+-----------------------------------------+
echo.	^|					  ^|
echo.	^|  1 -^> Express fix (recommended)	  ^|
echo.	^|					  ^|
echo.	^|  2 -^> Custom fix (advanced users only)  ^|
echo.	^|					  ^|
echo.	^|  3 -^> View README			  ^|
echo.	^|					  ^|
echo.	^|  4 -^> View FAQ			  ^|
echo.	^|					  ^|
echo.	^|  5 -^> View CHANGELOG			  ^|
echo.	^|					  ^|
echo.	^|					  ^|
echo.	^|  6 -^> Exit				  ^|
echo.	^|					  ^|
echo.	+-----------------------------------------+
choice /c 123456 /n
	if %errorlevel% EQU 1 goto setNoCustom
	if %errorlevel% EQU 2 goto customInstall
	if %errorlevel% EQU 3 goto openReadme
	if %errorlevel% EQU 4 goto openFAQ
	if %errorlevel% EQU 5 goto openChangelog
	if %errorlevel% EQU 6 exit
	

:openReadme
IF EXIST "README.html" (
start readme.html
) ELSE (
start https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/README.md
)
goto :welcome

:openChangelog
IF EXIST "changelog.html" (
start changelog.html
) ELSE (
start https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/CHANGELOG.md
)
goto :welcome

:openFAQ
IF EXIST "FAQ.html" (
start FAQ.html
) ELSE (
start https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/FAQ.md
)
goto :welcome

:setNoCustom
set nocustom=true
goto terms


::===================
::Custom Installation
::===================

:customInstall
call :print
echo Custom Options (advanced users only)
echo.
echo.
echo.	The fix process is divided into three stages. Use this menu to start
echo.	at the fix at a specific stage.
echo.
echo.
echo.	+---------------------------------------------------+
echo.	^|						    ^|
echo.	^|  1 -^> Reset all Windows Update Components	    ^|
echo.	^|						    ^|
echo.	^|  2 -^> Install the latest Windows Update Agent     ^|
echo.	^|						    ^|
echo.	^|  3 -^> Install KB3020369, KB3172605 and KB3102810  ^|
echo.	^|						    ^|
echo.	^|						    ^|
echo.	^|  4 -^> Go back				  	    ^|
echo.	^|						    ^|
echo.	+---------------------------------------------------+
	choice /c 1234 /n
	if %errorlevel% EQU 1 set nocustom=true && goto terms
	if %errorlevel% EQU 2 set custom2=true && set custom3=false && goto terms
	if %errorlevel% EQU 3 set custom2=false && set custom3=true && goto terms
	if %errorlevel% EQU 4 goto welcome


::============	
::TERMS OF USE
::============	

:terms
call :print
echo Terms of Use
echo.	
echo.	Please read the terms of use below:
echo.
echo.	This fix will modify sensitive system files. While it has been
echo.	tested extensively, the developer assumes no responsibility for 
echo.	any damage.
echo.
echo.
	choice /c YN /n /m "Do you accept the terms of use? [Y/N]"
	echo.
	if %errorlevel% EQU 1 goto decideArc
	if %errorlevel% EQU 2 goto termsDisagree

:decideArc
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set arc=32BIT || set arc=64BIT
	if %arc%==32BIT goto download32
	if %arc%==64BIT goto download64

::===================
::Initialize Download
::===================

:initializeDownload
echo.	Initializing...
net stop bits >nul 2>&1
net stop wuauserv >nul 2>&1
ipconfig /flushdns >nul 2>&1
ren "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr0.dat" qmgr0.dat.old >nul 2>&1
ren "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr1.dat" qmgr1.dat.old >nul 2>&1
net start bits >nul 2>&1
rmdir %systemdrive%\packages /s /q >nul 2>&1
md %systemdrive%\packages >nul 2>&1
set downProblem=false
goto :eof	
	
	
::=================
::Download (64-bit)
::=================

:download64
call :print
echo File Download (64-bit)
echo.
echo.	Please wait while the wizard downloads the required files.
echo.	This could take several minutes depending on your connection speed.
echo.
echo.	
echo.	Status:
echo.
echo.
call :initializeDownload
echo.	Done!

echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Downloading Update for Windows 7 (KB3020369)...
bitsadmin /transfer kb3020369 https://download.microsoft.com/download/5/D/0/5D0821EB-A92D-4CA2-9020-EC41D56B074F/Windows6.1-KB3020369-x64.msu "%systemdrive%\packages\3020369.msu" >nul 2>&1
	if %errorlevel% EQU 0 echo.	Success!
	if %errorlevel% NEQ 0 set downProblem=true && echo.	Download failed.
	
echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Downloading Update for Windows 7 (KB3172605)...
bitsadmin /transfer kb3172605 https://download.microsoft.com/download/5/6/0/560504D4-F91A-4DEB-867F-C713F7821374/Windows6.1-KB3172605-x64.msu "%systemdrive%\packages\3172605.msu" >nul
	if %errorlevel% EQU 0 echo.	Success!
	if %errorlevel% NEQ 0 set downProblem=true && echo.	Download failed.
	
echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Downloading Update for Windows 7 (KB3102810)...
bitsadmin /transfer kb3172605 https://download.microsoft.com/download/F/A/A/FAABD5C2-4600-45F8-96F1-B25B137E3C87/Windows6.1-KB3102810-x64.msu "%systemdrive%\packages\3102810.msu" >nul
	if %errorlevel% EQU 0 echo.	Success!
	if %errorlevel% NEQ 0 set downProblem=true && echo.	Download failed.
	
echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Downloading Windows Update Agent Version 7.6...
bitsadmin /transfer kb3172605 http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/windowsupdateagent-7.6-x64.exe "%systemdrive%\packages\wua.exe" >nul
	if %errorlevel% EQU 0 echo.	Success!
	if %errorlevel% NEQ 0 set downProblem=true && echo.	Download failed.
	
echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Copying files...
xcopy /v /y readme.txt %systemdrive%\packages >nul 2>&1
xcopy /v /y changelog.txt %systemdrive%\packages >nul 2>&1
xcopy /v /y updates.bat %systemdrive%\packages >nul 2>&1
xcopy /v /y cleanup.bat %systemdrive%\packages >nul 2>&1
set cnt=0
	for %%A in (%systemdrive%\packages\*) do set /a cnt+=1
	if %cnt% EQU 8 if %cnt% EQU 6 echo.	Success!
	if %cnt% NEQ 8 if %cnt% NEQ 6 set downProblem=true && echo.	Copy failed.

echo.
echo.
	if %downProblem%==true goto downFail
	if %downProblem%==false goto downSuccess


::=================
::Download (32-bit)
::=================

:download32
call :print
echo File Download (32-bit)
echo.
echo.	Please wait while the wizard downloads the required files.
echo.	This could take several minutes depending on your connection speed.
echo.
echo.	
echo.	Status:
echo.
echo.
call :initializeDownload
echo.	Done!

echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Downloading Update for Windows 7 (KB3020369)...
bitsadmin /transfer kb3020369 https://download.microsoft.com/download/C/0/8/C0823F43-BFE9-4147-9B0A-35769CBBE6B0/Windows6.1-KB3020369-x86.msu "%systemdrive%\packages\3020369.msu" >nul 2>&1
	if %errorlevel% EQU 0 echo.	Success!
	if %errorlevel% NEQ 0 set downProblem=true && echo.	Download failed.

echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Downloading Update for Windows 7 (KB3172605)...
bitsadmin /transfer kb3172605 https://download.microsoft.com/download/C/D/5/CD5DE7B2-E857-4BD4-AA9C-6B30C3E1735A/Windows6.1-KB3172605-x86.msu "%systemdrive%\packages\3172605.msu" >nul
	if %errorlevel% EQU 0 echo.	Success!
	if %errorlevel% NEQ 0 set downProblem=true && echo.	Download failed.

echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Downloading Update for Windows 7 (KB3102810)...
bitsadmin /transfer kb3172605 https://download.microsoft.com/download/A/0/9/A09BC0FD-747C-4B97-8371-1A7F5AC417E9/Windows6.1-KB3102810-x86.msu "%systemdrive%\packages\3102810.msu" >nul
	if %errorlevel% EQU 0 echo.	Success!
	if %errorlevel% NEQ 0 set downProblem=true && echo.	Download failed.

echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Downloading Windows Update Agent Version 7.6...
bitsadmin /transfer kb3172605 http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/windowsupdateagent-7.6-x86.exe "%systemdrive%\packages\wua.exe" >nul
	if %errorlevel% EQU 0 echo.	Success!
	if %errorlevel% NEQ 0 set downProblem=true && echo.	Download failed.

echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Copying files...
xcopy /v /y README.html %systemdrive%\packages >nul 2>&1
xcopy /v /y FAQ.html %systemdrive%\packages >nul 2>&1
xcopy /v /y CHANGELOG.html %systemdrive%\packages >nul 2>&1
xcopy /v /y updates.bat %systemdrive%\packages >nul 2>&1
xcopy /v /y cleanup.bat %systemdrive%\packages >nul 2>&1
set cnt=0
	for %%A in (%systemdrive%\packages\*) do set /a cnt+=1
	if %cnt% EQU 9 if %cnt% EQU 6 echo.	Success!
	if %cnt% NEQ 9 if %cnt% NEQ 6 set downProblem=true && echo.	Copy failed.

echo.
echo.
	if %downProblem%==true goto downFail
	if %downProblem%==false goto downSuccess


::===========
::Check Files
::===========

:downFail
timeout /t 3 /nobreak>nul
echo.	The wizard could not download one or more of the required files.
echo.	Please contact the developer for help.
echo.
echo.	Press any key to exit.
pause>nul
exit

:downSuccess
timeout /t 3 /nobreak>nul
echo.	All files were downloaded successfully.
timeout /t 5 /nobreak>nul
goto restorePoint


::=============
::RESTORE POINT	
::=============

:restorePoint
call :print
echo Restore Point
echo.
echo.	Before continuing, the wizard can create a restore point for you.
echo.	The restore point can be used to undo any changes if necessary. 
echo.
echo.
	choice /c YN /n /m "Would you like to create a restore point? [Y/N]"
	if %errorlevel% EQU 1 goto createRP
	if %errorlevel% EQU 2 goto decideCustom
	
:decideCustom
	if %nocustom%==true goto ready
	if %custom2%==true goto ready2
	if %custom3%==true goto ready3

:createRP
call :print
echo Restore Point
echo.
echo.	Please wait while the restore point is created on the system. 
echo.	This might take several minutes to complete.
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "wizard", 100, 1 >nul 2>&1
	if %errorlevel% EQU 0 (
	goto successRP
	) else (
	goto failRP
	)
	
:successRP
echo.
echo.	Success!
timeout /t 4 /nobreak>nul		
goto decideCustom

:failRP
echo.
echo.	The restore point could not be created. The required service
echo.	might be disabled.
echo.
echo.
echo Press any key to continue.
pause>nul
goto decideCustom


::==============
::READY TO BEGIN
::==============
	
:ready
call :print
echo Ready to Begin
echo.
echo.	The wizard is now ready to begin the fix process. Your computer will 
echo.	restart several times during this process.
echo.
echo.	It is strongly recommended that you disconnect from the Internet now.
echo.
echo.	Save all work and press any key to begin.
pause>nul
goto reset


::================
::READY TO BEGIN 2
::================
	
:ready2
call :print
echo Ready to Begin (Stage 2)
echo.
echo.	The wizard is now ready to begin the fix process. Your computer will 
echo.	restart several times during this process.
echo.
echo.	It is strongly recommended that you disconnect from the Internet now.
echo.
echo.	Save all work and press any key to begin stage 2.
pause>nul
goto wua


::================
::READY TO BEGIN 3
::================

:ready3
call :print
echo Ready to Begin (Stage 3)
echo.
echo.	The wizard is now ready to begin the fix process. Your computer will 
echo.	restart several times during this process.
echo.
echo.	It is strongly recommended that you disconnect from the Internet now.
echo.
echo.	Save all work and press any key to begin stage 3.
pause>nul
call %systemdrive%\packages\updates.bat
exit


::=======
::STAGE 1
::=======

:reset
call :print
echo Stage 1 of 3
echo.
echo.	Please wait while the wizard runs the following actions:
echo.
echo.

echo.	-^> Stopping services...
net stop bits /y >nul 2>&1
net stop wuauserv /y >nul 2>&1
net stop appidsvc /y >nul 2>&1
net stop cryptsvc /y >nul 2>&1
echo.

echo.	-^> Deleting qmgr*.dat files...
Del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat">nul 2>&1
timeout /t 3 /nobreak>nul
echo.

echo.	-^> Deleting SoftwareDistribution folders...
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

echo.	-^> Resetting BITS and WUAUSERV to default security descriptors...
sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)>nul 2>&1
sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)>nul 2>&1
echo.

echo.	-^> Reregistering BITS and Windows Update files...
echo.
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
timeout /t 5 /nobreak>nul

echo.	-^> Resetting Winsock...
netsh winsock reset >nul 2>&1
echo.

echo.	-^> Resetting WinHTTP proxy...
echo.
	if %family% EQU 5 (
		proxycfg.exe -d >nul 2>&1
	) else (
		netsh winhttp reset proxy >nul 2>&1
	)

echo.	-^> Configuring service startup types...
sc config wuauserv start= auto  >nul 2>&1
sc config bits start= auto  >nul 2>&1
sc config DcomLaunch start= auto  >nul 2>&1
sc config appidsvc start= auto  >nul 2>&1
sc config cryptsvc start=auto >nul 2>&1
echo. 

echo.	-^> Restarting services...
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
net start appidsvc >nul 2>&1
net start cryptsvc >nul 2>&1
net start DcomLaunch >nul 2>&1

goto wua


::=======
::STAGE 2
::=======

:wua
call :print
echo Stage 2 of 3
echo.
echo.	Please wait while the wizard installs the latest Windows Update Agent.
echo.	This might take several minutes to complete.
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
	goto already
	)
	IF NOT %errorlevel%==0 IF NOT %errorlevel%==2359302 (
	goto installFail
	)	


::===========	
::ERROR CODES
::===========

:corrupt
echo.	The required package is corrupt or missing.
echo.
echo.
echo Press any key to continue.
pause>nul
goto restart

:success
echo.	Success!
timeout /t 4 /nobreak>nul
goto restart

:already
echo.	The latest agent was already installed.
timeout /t 4 /nobreak>nul
goto restart

:installFail
echo.	Stage 2 of 3 failed. The error code is %errorlevel%.
echo.
echo.
echo Press any key to continue.
pause>nul
goto restart


::=====================
::TERMS OF USE DISAGREE
::=====================

:termsDisagree
cls
call :print
echo Failure
echo.
echo.	You did not accept the terms of use.
echo.
echo.
echo Press any key to exit.
pause>nul
exit


::================
::RESTART COMPUTER
::================

:restart
call :print
timeout /t 1 /nobreak>nul
echo Restart Computer
echo.
echo.	Your computer needs to restart to continue installation.
echo.	The wizard will reopen after you log back on. 
echo.	
echo.	Restarting in a moment...
timeout /t 8 /nobreak>nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce /v updatesinstall /t REG_EXPAND_SZ /d %systemdrive%\packages\updates.bat >nul 2>&1
shutdown -r -t 0

