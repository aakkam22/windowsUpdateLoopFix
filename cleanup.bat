::=============================
::NAME: Windows Update Loop Fix
::VERSION: 4.1.1
::AUTHOR: aakkam22
::=============================


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
goto cleanup


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


::=======	
::CLEANUP
::=======

:cleanup
call :print
echo Cleanup
echo.
echo.	The wizard is cleaning up...
timeout /t 4 /nobreak>nul
del /q %systemdrive%\packages\3020369.msu >nul 2>&1
del /q %systemdrive%\packages\3172605.msu >nul 2>&1
del /q %systemdrive%\packages\3102810.msu >nul 2>&1
del /q %systemdrive%\packages\updates.bat >nul 2>&1
del /q %systemdrive%\packages\wua.exe >nul 2>&1
goto summary


::=======	
::SUMMARY
::=======

:summary
call :print
echo Summary
echo.
echo.	The fix has finished processing. You can now check for new updates.
echo.
echo.	Please be patient when checking for updates for the first time
echo.	because Windows Update might still be registering brand new components.
echo.
echo.
echo.	What would you like to do?
echo.
echo.
echo.	+---------------------------------------------------+
echo.	^|						    ^|
echo.	^|  1 -^> Open Windows Update			    ^|
echo.	^|						    ^|
echo.	^|  2 -^> Go online to get Windows 7 Service Pack 2   ^|
echo.	^|						    ^|
echo.	^|  3 -^> View README				    ^|
echo.	^|						    ^|
echo.	^|  4 -^> View FAQ				    ^|
echo.	^|						    ^|
echo.	^|  5 -^> View CHANGELOG				    ^|
echo.	^|						    ^|
echo.	^|						    ^|
echo.	^|  6 -^> Exit					    ^|
echo.	^|						    ^|
echo.	+---------------------------------------------------+
	choice /c 123456 /n
	if %errorlevel% EQU 1 goto wuApp
	if %errorlevel% EQU 2 goto SP2
	if %errorlevel% EQU 3 goto openReadme
	if %errorlevel% EQU 4 goto openFAQ
	if %errorlevel% EQU 5 goto openChangelog
	if %errorlevel% EQU 6 exit

:wuApp
start wuapp.exe
goto summary

:SP2
start https://answers.microsoft.com/en-us/windows/forum/windows_7-update/how-to-update-windows-7-using-the-convenience/c2c7009f-3a10-4199-9c89-48e1e883051e
goto summary

:openReadme
IF EXIST "%systemdrive%\packages\README.html" (
start %systemdrive%\packages\README.html
) ELSE (
start https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/README.md
)
goto summary

:openFAQ
IF EXIST "%systemdrive%\packages\FAQ.html" (
start %systemdrive%\packages\FAQ.html
) ELSE (
start https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/FAQ.md
)
goto summary

:openChangelog
IF EXIST "%systemdrive%\packages\CHANGELOG.html" (
start %systemdrive%\packages\CHANGELOG.html
) ELSE (
start https://github.com/aakkam22/windowsUpdateLoopFix/blob/master/CHANGELOG.md
)
goto summary


:quit
del /q %systemdrive%\packages\README.html >nul 2>&1
del /q %systemdrive%\packages\FAQ.html >nul 2>&1
del /q %systemdrive%\packages\CHANGELOG.html.html >nul 2>&1
SETLOCAL >nul 2>&1
SET someOtherProgram=SomeOtherProgram.exe >nul 2>&1
TASKKILL /IM "%someOtherProgram%" >nul 2>&1
DEL "%~f0" >nul 2>&1
exit 

