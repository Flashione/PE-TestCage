@echo off
setlocal EnableExtensions

if "%LOGDIR%"=="" set "LOGDIR=%TEMP%"

echo [MOCK wpeutil] %* >> "%LOGDIR%\wpeutil.log"

echo.
echo [MOCK wpeutil] %*
echo.

exit /b 0
