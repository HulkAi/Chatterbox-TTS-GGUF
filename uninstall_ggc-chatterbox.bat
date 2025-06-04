@echo off
setlocal EnableDelayedExpansion

REM Prevent script from closing on conda command issues
set "CONDA_ACTIVATE_BASE=false"

echo ========================================================================
echo Chatterbox TTS (GGUF Fixed Version) - Uninstaller - ROBUST VERSION
echo ========================================================================
echo.
echo This script will attempt to remove the Conda environment created for
echo Chatterbox TTS and provide guidance for further cleanup.
echo.

REM --- Configuration: Set the Conda environment name ---
set ENV_NAME=chatterbox-tts-env
REM IMPORTANT: This ENV_NAME MUST match the one used in the setup script

REM Get script directory and navigate there
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"
echo Script directory: %SCRIPT_DIR%
echo Environment to remove: %ENV_NAME%
echo.

REM Initialize Conda for this script
echo Initializing Conda...
REM First, check if conda is already in PATH
set "CONDA_FOUND=false"
where conda >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call conda activate >nul 2>&1
    set "CONDA_FOUND=true"
) else (
    REM Try common Conda installation paths
    for %%C in (
        "%USERPROFILE%\Miniconda3"
        "%ProgramData%\Miniconda3"
        "%USERPROFILE%\Anaconda3"
        "%ProgramData%\Anaconda3"
    ) do (
        if exist "%%~C\Scripts\conda.exe" (
            call "%%~C\Scripts\activate.bat" "%%~C" >nul 2>&1
            if !ERRORLEVEL! equ 0 (
                set "CONDA_FOUND=true"
                set "CONDA_ROOT=%%~C"
            )
        )
    )
)

REM Check if Conda was found
if "!CONDA_FOUND!"=="false" (
    echo ERROR: Conda installation not found in PATH or expected locations.
    echo Please ensure Miniconda or Anaconda is installed and added to PATH.
    echo.
    pause
    goto :KeepOpenForever
)

REM Check if Conda is available
echo Checking for Conda...
call conda --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Conda command failed. Please ensure Miniconda or Anaconda is properly installed.
    echo.
    pause
    goto :KeepOpenForever
)
echo Conda found.
echo.

REM --- Direct Conda Operations (No temp file needed) ---
echo Checking if Conda environment '%ENV_NAME%' exists...

REM Create a temporary file to capture conda env list output
set "TEMP_ENV_LIST=%TEMP%\conda_env_list_%RANDOM%.txt"
call conda env list > "%TEMP_ENV_LIST%" 2>&1

REM Check if our environment exists
findstr /B /C:"%ENV_NAME% " "%TEMP_ENV_LIST%" >nul 2>&1
set "ENV_EXISTS_RESULT=%ERRORLEVEL%"

REM Clean up temp file
if exist "%TEMP_ENV_LIST%" del "%TEMP_ENV_LIST%"

if %ENV_EXISTS_RESULT% equ 1 (
    echo Conda environment '%ENV_NAME%' not found or already removed.
    echo Skipping environment removal.
    echo.
) else (
    echo Found Conda environment '%ENV_NAME%'.
    echo.
    set /p "CONFIRM_REMOVE_ENV=Are you sure you want to remove the Conda environment '%ENV_NAME%'? (y/n): "
    if /i "!CONFIRM_REMOVE_ENV!"=="y" (
        echo Removing Conda environment '%ENV_NAME%'. This may take a moment...
        echo.
        call conda env remove -n %ENV_NAME% -y
        if errorlevel 1 (
            echo ERROR: Failed to remove Conda environment '%ENV_NAME%'.
            echo You may need to remove it manually or check Conda logs.
        ) else (
            echo Successfully removed Conda environment '%ENV_NAME%'.
        )
    ) else (
        echo Skipped removal of Conda environment '%ENV_NAME%'.
    )
)

echo.
echo ========================================================================
echo Manual Cleanup Steps
echo ========================================================================
echo.
echo **Cached GGUF Models:**
echo The GGUF model used by Chatterbox TTS is typically downloaded automatically
echo by 'gguf-connector' to a cache directory. This script cannot safely
echo delete these files automatically.
echo.
echo To free up disk space, manually delete cached models from locations like:
echo   - %USERPROFILE%\.cache\gguf-connector
echo   - %USERPROFILE%\.cache\chichat
echo   - (Look for folders related to 'gguf', 'chichat', or model names)
echo Be careful not to delete caches for other applications.
echo.
echo **Project Folder:**
echo This uninstaller does not delete the project folder itself ('%SCRIPT_DIR%').
echo If you wish to remove all application files, manually delete this folder.
echo.

:KeepOpenForever
echo ========================================================================
echo Main uninstall script has completed its tasks.
echo Press any key to exit...
echo ========================================================================
pause
exit /b 0