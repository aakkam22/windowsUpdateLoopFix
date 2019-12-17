@echo off

REM NAME: Windows Update Loop Fix
REM VERSION: 5.0
REM BUILD DATE: 17 December 2019
REM AUTHOR: aakkam22

REM Function to elevate privileges
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

call :setWindow
goto determineArc

REM Function to set the window properties
:setWindow
title Windows Update Loop Fix
mode con cols=80 lines=40
goto :eof

REM Function to print header
:printHeader
cls
echo.
echo %screen%
echo.
goto :eof

REM determine whether the system is 32 or 64-bit
:determineArc
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set arc=32BIT || set arc=64BIT >nul 2>&1
	if %arc%==32BIT goto firstInstall32
	if %arc%==64BIT goto firstInstall64

:updateHeader
set screen=Stage 3 of 3 (Installing Updates)
call :printHeader
echo Please wait while the updates are installed.
echo.
goto :eof

REM kb3020369 installation for 32-bit systems
:firstInstall32
call :updateHeader
echo Installing KB3020369...
timeout /t 5 /nobreak>nul
REM check if previous directory exists and remove it
rmdir %systemdrive%\packages\3020369 /s /q >nul 2>&1 
md %systemdrive%\packages\3020369
expand -f:* "%systemdrive%\packages\3020369.msu" "%systemdrive%\packages\3020369" >nul 2>&1

dism.exe /online /add-package /packagepath:"%systemdrive%\packages\3020369\Windows6.1-KB3020369-x86.cab" /norestart /logpath:"%systemdrive%\install.log"
timeout /t 5 /nobreak>nul
goto secondInstall32

REM kb3172605 installation for 32-bit systems
:secondInstall32
call :updateHeader
echo Installing KB3172605...
REM check if previous directory exists and remove it
rmdir %systemdrive%\packages\3172605 /s /q >nul 2>&1
md %systemdrive%\packages\3172605
expand -f:* "%systemdrive%\packages\3172605.msu" "%systemdrive%\packages\3172605" >nul 2>&1

dism.exe /online /add-package /packagepath:"%systemdrive%\packages\3172605\Windows6.1-KB3172605-x86.cab" /norestart /logpath:"%systemdrive%\install.log"
echo.
timeout /t 7
goto restart

REM kb3020369 installation for 64-bit systems
:firstInstall64
call :updateHeader
echo Installing KB3020369...
timeout /t 5 /nobreak>nul
REM check if previous directory exists and remove it
rmdir %systemdrive%\packages\3020369 /s /q >nul 2>&1 
md %systemdrive%\packages\3020369
expand -f:* "%systemdrive%\packages\3020369.msu" "%systemdrive%\packages\3020369" >nul 2>&1

dism.exe /online /add-package /packagepath:"%systemdrive%\packages\3020369\Windows6.1-KB3020369-x64.cab" /norestart /logpath:"%systemdrive%\install.log"
timeout /t 5 /nobreak>nul
goto secondInstall64

REM kb3172605 installation for 64-bit systems
:secondInstall64
call :updateHeader
echo Installing KB3172605...
REM check if previous directory exists and remove it
rmdir %systemdrive%\packages\3172605 /s /q >nul 2>&1
md %systemdrive%\packages\3172605
expand -f:* "%systemdrive%\packages\3172605.msu" "%systemdrive%\packages\3172605" >nul 2>&1

dism.exe /online /add-package /packagepath:"%systemdrive%\packages\3172605\Windows6.1-KB3172605-x64.cab" /norestart /logpath:"%systemdrive%\install.log"
echo.
timeout /t 7
goto restart

REM set the RunOnce registry key to execute the cleanup.cmd script, then restart the computer
:restart
set screen=Restart Computer
call :printHeader
echo Your computer needs to restart to continue. 
echo The script will continue after you log back on.
echo.
timeout /t 7
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce /v updatesinstall /t REG_EXPAND_SZ /d %systemdrive%\packages\cleanup.cmd >nul 2>&1
shutdown -r -t 0
