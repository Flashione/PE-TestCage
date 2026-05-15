@echo off
setlocal EnableExtensions

if "%LOGDIR%"=="" set "LOGDIR=%TEMP%"

echo [MOCK net] %* >> "%LOGDIR%\net.log"

echo.
echo [MOCK net] %*
echo.

exit /b 0
