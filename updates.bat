::==============================
::NAME: Windows Update Loop Fix
::VERSION: 4.1.1
::AUTHOR: aakkam22
::==============================


::===========
::CHECK ADMIN
::===========

@echo off

:checkAdmin
fsutil dirty query %systemdrive% >nul
	if '%errorlevel%' NEQ '0' (
		echo Requesting administrative privileges...
		goto uacPrompt
	) else ( goto gotAdmin )

:uacPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"

call :mode
goto installUpdates


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
	

::==================
::Installing Updates
::==================

:installUpdates
call :print
echo Stage 3 of 3
echo.
echo.	Please wait while the wizard installs the required updates. 
echo.	This will take several minutes to complete.
echo.
echo.
echo.	Status:

echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Installing Update for Windows (KB3020369)...
wusa.exe %systemdrive%\packages\3020369.msu /quiet /norestart
	IF %errorlevel%==0 echo.	Success!

	IF %errorlevel%==-2145124329 IF NOT %errorlevel%==0 echo.	The update is already installed. 

	IF %errorlevel%==1609 IF NOT %errorlevel%==0 echo.	The required file is missing or corrupt.
	
	IF %errorlevel%==2 IF NOT %errorlevel%==1609 IF NOT %errorlevel%==0 echo.	The required file is missing or corrupt.
	
	IF %errorlevel%==2359302 IF NOT %errorlevel%==0 echo.	The update is already installed.

	IF %errorlevel%==3010 IF NOT %errorlevel%==0 echo.	Success!

	IF NOT %errorlevel%==0 IF NOT %errorlevel%==2359302 IF NOT %errorlevel%==3010 IF NOT %errorlevel%==-2145124329 IF NOT %errorlevel%==2 echo.	KB3020369 failed to install. The error code is %errorlevel%. 

echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Installing Update for Windows (KB3172605)...
wusa.exe %systemdrive%\packages\3172605.msu /quiet /norestart
	IF %errorlevel%==0 echo.	Success!

	IF %errorlevel%==-2145124329 IF NOT %errorlevel%==0 echo.	The update is already installed. 

	IF %errorlevel%==1609 IF NOT %errorlevel%==0 echo.	The required file is missing or corrupt.
	
	IF %errorlevel%==2 IF NOT %errorlevel%==1609 IF NOT %errorlevel%==0 echo.	The required file is missing or corrupt.
	
	IF %errorlevel%==2359302 IF NOT %errorlevel%==0 echo.	The update is already installed.

	IF %errorlevel%==3010 IF NOT %errorlevel%==0 echo.	Success!

	IF NOT %errorlevel%==0 IF NOT %errorlevel%==2359302 IF NOT %errorlevel%==3010 IF NOT %errorlevel%==-2145124329 IF NOT %errorlevel%==2 echo.	KB3172605 failed to install. The error code is %errorlevel%.

echo.
echo.
timeout /t 3 /nobreak>nul
echo.	Installing Update for Windows (KB3102810)...
wusa.exe %systemdrive%\packages\3102810.msu /quiet /norestart
	IF %errorlevel%==0 echo.	Success!

	IF %errorlevel%==-2145124329 IF NOT %errorlevel%==0 echo.	The update is already installed. 

	IF %errorlevel%==1609 IF NOT %errorlevel%==0 echo.	The required file is missing or corrupt.
	
	IF %errorlevel%==2 IF NOT %errorlevel%==1609 IF NOT %errorlevel%==0 echo.	The required file is missing or corrupt.
	
	IF %errorlevel%==2359302 IF NOT %errorlevel%==0 echo.	The update is already installed.

	IF %errorlevel%==3010 IF NOT %errorlevel%==0 echo.	Success!

	IF NOT %errorlevel%==0 IF NOT %errorlevel%==2359302 IF NOT %errorlevel%==3010 IF NOT %errorlevel%==-2145124329 IF NOT %errorlevel%==2 echo.	KB3102810 failed to install. The error code is %errorlevel%.
echo.
echo.
timeout /t 5 /nobreak>nul
goto restart


::================
::RESTART COMPUTER
::================

:restart
call :print
timeout /t 1 /nobreak>nul
echo Restart Computer
echo.
echo.	Your computer needs to restart to finish installation.
echo.	The wizard will reopen after you log back on. 
echo.	
echo.	Restarting in a moment...
timeout /t 8 /nobreak>nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce /v cleanup /t REG_EXPAND_SZ /d %systemdrive%\packages\cleanup.bat >nul 2>&1
shutdown.exe -r -t 0

