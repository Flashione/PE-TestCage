@echo off
setlocal EnableExtensions

if "%LOGDIR%"=="" set "LOGDIR=%TEMP%"

echo [MOCK dism] %* >> "%LOGDIR%\dism.log"

echo.
echo Deployment Image Servicing and Management tool
echo [MOCK MODE]
echo.
echo Command:
echo dism %*
echo.
echo [MOCK] No image was applied, captured or modified.
echo [MOCK] Operation completed successfully.
echo.

exit /b 0
