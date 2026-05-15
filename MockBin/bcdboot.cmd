@echo off
setlocal EnableExtensions

if "%LOGDIR%"=="" set "LOGDIR=%TEMP%"

echo [MOCK bcdboot] %* >> "%LOGDIR%\bcdboot.log"

echo.
echo [MOCK bcdboot]
echo Command:
echo bcdboot %*
echo.
echo [MOCK] Boot files would be created here.
echo.

exit /b 0
