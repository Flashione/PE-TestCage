@echo off
setlocal EnableExtensions

set "CAGE=%~dp0"
set "CAGE=%CAGE:~0,-1%"

set "MOCKBIN=%CAGE%\MockBin"
set "TEMP=%CAGE%\Temp"
set "TMP=%CAGE%\Temp"
set "LOGDIR=%CAGE%\Logs"

if "%~1"=="" (
    set "TARGET="
) else (
    set "TARGET=%~1"
)

if not "%TARGET%"=="" (
    if exist "%CAGE%\%TARGET%" set "TARGET=%CAGE%\%TARGET%"
)

mkdir "%TEMP%" 2>nul
mkdir "%LOGDIR%" 2>nul
mkdir "%CAGE%\Drives\S" 2>nul
mkdir "%CAGE%\Drives\W\Windows" 2>nul
mkdir "%CAGE%\Drives\Z" 2>nul

echo.
echo ==========================================
echo  PE-TestCage
echo ==========================================
echo.
echo Cage root:
echo %CAGE%
echo.

if not "%TARGET%"=="" (
    echo Target script:
    echo %TARGET%
    echo.
)

if exist S:\ (
    echo ERROR: Drive S: already exists.
    echo Remove the drive mapping or adjust the cage configuration.
    pause
    exit /b 1
)

if exist W:\ (
    echo ERROR: Drive W: already exists.
    echo Remove the drive mapping or adjust the cage configuration.
    pause
    exit /b 1
)

if exist Z:\ (
    echo ERROR: Drive Z: already exists.
    echo Remove the drive mapping or adjust the cage configuration.
    pause
    exit /b 1
)

subst S: "%CAGE%\Drives\S"
subst W: "%CAGE%\Drives\W"
subst Z: "%CAGE%\Drives\Z"

if errorlevel 1 (
    echo ERROR: Failed to create cage drive mappings.
    pause
    exit /b 1
)

set "PATH=%MOCKBIN%;%PATH%"

echo Cage active.
echo.
echo S: = %CAGE%\Drives\S
echo W: = %CAGE%\Drives\W
echo Z: = %CAGE%\Drives\Z
echo.
echo Dangerous commands are mocked through:
echo %MOCKBIN%
echo.

if "%TARGET%"=="" (
    echo Starting interactive cage shell.
    echo Type exit to close the cage.
    echo.
    cmd /k
) else (
    if not exist "%TARGET%" (
        echo ERROR: Target script not found.
        echo %TARGET%
        echo.
        goto CLOSE_CAGE
    )

    call "%TARGET%"
)

:CLOSE_CAGE
echo.
echo Closing PE-TestCage...

subst S: /d >nul 2>&1
subst W: /d >nul 2>&1
subst Z: /d >nul 2>&1

echo Cage closed.
echo.
pause
exit /b 0
