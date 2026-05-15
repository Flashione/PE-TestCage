@echo off
setlocal EnableExtensions

if "%LOGDIR%"=="" set "LOGDIR=%TEMP%"

echo [MOCK diskpart] %* >> "%LOGDIR%\diskpart.log"

set "SCRIPT="
if /I "%~1"=="/s" set "SCRIPT=%~2"

if not "%SCRIPT%"=="" (
    echo [MOCK diskpart] Script: %SCRIPT% >> "%LOGDIR%\diskpart.log"
    if exist "%SCRIPT%" (
        type "%SCRIPT%" >> "%LOGDIR%\diskpart.log"
    ) else (
        echo [MOCK diskpart] Script file not found. >> "%LOGDIR%\diskpart.log"
    )
    echo. >> "%LOGDIR%\diskpart.log"
)

if not "%SCRIPT%"=="" (
    findstr /i /c:"list disk" "%SCRIPT%" >nul 2>&1
    if not errorlevel 1 (
        echo.
        echo   Disk ###  Status         Size     Free     Dyn  Gpt
        echo   --------  -------------  -------  -------  ---  ---
        echo   Disk 0    Online           64 GB      0 B        *
        echo   Disk 1    Online          128 GB      0 B        *
    )

    findstr /i /c:"list volume" "%SCRIPT%" >nul 2>&1
    if not errorlevel 1 (
        echo.
        echo   Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
        echo   ----------  ---  -----------  -----  ----------  -------  ---------  --------
        echo   Volume 0     S   System       FAT32  Partition    200 MB  Healthy    System
        echo   Volume 1     W   Windows      NTFS   Partition     63 GB  Healthy
        echo   Volume 2     Z   Deploy       NTFS   Partition     20 GB  Healthy
    )
)

exit /b 0
