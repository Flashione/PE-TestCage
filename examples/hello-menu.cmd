@echo off
setlocal EnableExtensions

:MENU
cls
echo.
echo ==========================================
echo  PE-TestCage Example Menu
echo ==========================================
echo.
echo 1 - Show fake disks
echo 2 - Mock DISM apply
echo 3 - Mock bootloader creation
echo 4 - Mock reboot
echo 5 - Exit
echo.

set "OPTION="
set /p OPTION=Select option: 

if "%OPTION%"=="1" goto DISKS
if "%OPTION%"=="2" goto DISM
if "%OPTION%"=="3" goto BCDBOOT
if "%OPTION%"=="4" goto REBOOT
if "%OPTION%"=="5" exit /b 0

goto MENU

:DISKS
(
echo list disk
echo list volume
echo exit
) > "%temp%\example_diskpart.txt"

diskpart /s "%temp%\example_diskpart.txt"
pause
goto MENU

:DISM
dism /Apply-Image /ImageFile:"Z:\Images\Example.wim" /Index:1 /ApplyDir:W:\ /CheckIntegrity
pause
goto MENU

:BCDBOOT
bcdboot W:\Windows /s S: /f ALL
pause
goto MENU

:REBOOT
wpeutil reboot
pause
goto MENU
