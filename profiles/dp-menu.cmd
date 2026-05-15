@echo off
setlocal EnableExtensions

echo.
echo ==========================================
echo  DP-Menu-Bat Profile
echo ==========================================
echo.

set "DPMENU=Z:\DP-Menu-Bat\Menu\Menu.bat"

if not exist "%DPMENU%" (
    echo ERROR: DP-Menu-Bat was not found inside the fake Z: drive.
    echo.
    echo Expected:
    echo %DPMENU%
    echo.
    echo Copy or clone DP-Menu-Bat into:
    echo Drives\Z\DP-Menu-Bat
    echo.
    pause
    exit /b 1
)

echo Starting:
echo %DPMENU%
echo.

call "%DPMENU%"

endlocal
exit /b 0
