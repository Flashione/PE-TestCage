@echo off
setlocal EnableExtensions

if "%LOGDIR%"=="" set "LOGDIR=%TEMP%"

echo [MOCK shutdown] %* >> "%LOGDIR%\shutdown.log"

echo.
echo [MOCK shutdown]
echo Shutdown or reboot blocked by PE-TestCage.
echo Command:
echo shutdown %*
echo.

exit /b 0
