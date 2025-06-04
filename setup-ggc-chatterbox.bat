@echo off
setlocal enabledelayedexpansion

REM Prevent script from closing on conda command issues
set "CONDA_ACTIVATE_BASE=false"

echo ========================================================================
echo Chatterbox TTS Environment Setup - ROBUST VERSION
echo ========================================================================

REM Get script directory and navigate there
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

set ENV_NAME=chatterbox-tts-env
set PYTHON_VERSION=3.11

echo Script directory: %SCRIPT_DIR%
echo Environment name: %ENV_NAME%
echo.

REM Check files exist first
if not exist environment.yml (
    if not exist requirements.txt (
        echo ERROR: Neither environment.yml nor requirements.txt found!
        goto :KeepOpenForever
    )
)

echo Found configuration files. Starting environment setup...
echo.

REM Use a separate batch file approach to handle conda properly
echo Creating conda command file...
echo @echo off > temp_conda_setup.bat
echo setlocal >> temp_conda_setup.bat

if exist environment.yml (
    echo echo Creating environment from environment.yml... >> temp_conda_setup.bat
    echo conda env create -f environment.yml >> temp_conda_setup.bat
) else (
    echo echo Creating environment with Python %PYTHON_VERSION%... >> temp_conda_setup.bat
    echo conda create -n %ENV_NAME% python=%PYTHON_VERSION% -y >> temp_conda_setup.bat
    echo echo Installing requirements... >> temp_conda_setup.bat
    echo call conda activate %ENV_NAME% >> temp_conda_setup.bat
    echo pip install -r requirements.txt >> temp_conda_setup.bat
    echo call conda deactivate >> temp_conda_setup.bat
)

echo echo. >> temp_conda_setup.bat
echo echo Setup completed! >> temp_conda_setup.bat
echo pause >> temp_conda_setup.bat
echo endlocal >> temp_conda_setup.bat

echo.
echo Running conda setup (this will open a new window)...
echo The new window will stay open when finished.
echo.

REM Run the conda commands in a separate process
call temp_conda_setup.bat

REM Clean up
if exist temp_conda_setup.bat del temp_conda_setup.bat

echo.
echo ========================================================================
echo Main setup script completed
echo ========================================================================

:KeepOpenForever
echo.
echo This window will stay open.
echo To close: Press Ctrl+C or close the window manually.
echo.
:Loop
timeout /t 5 /nobreak >nul
echo [Still running - %time%]
goto :Loop