# Chatterbox TTS (GGUF Fixed Version) - Setup Guide

Welcome! This guide helps you set up and run a modified version of Chatterbox TTS,
optimized for GGUF models on your CPU.


**Project Structure:**
The project folder you downloaded should contain the following key files and directories:
resemble-ai/
├── chatterbox/              # Original Chatterbox source code
├── models/                  # Can be a target for model downloads (see notes)
├── chatterbox_fix.py        # Custom Python fixes
├── gradio_patch.py          # Custom Gradio patches
├── requirements.txt         # Pip dependencies
├── environment.yml          # Conda environment definition
├── setup_environment.bat    # Script to set up the Conda environment
├── run-ggc-chatterbox.bat   # Script to run the application
└── README_SETUP.md          # This guide

---


## 1. Prerequisites - Essential First Steps!

Before you begin, please ensure your Windows system has the following:

*   **Conda (Miniconda or Anaconda):** **Required.**
    *   **Download:** Miniconda is recommended: [https://docs.conda.io/en/latest/miniconda.html](https://docs.conda.io/en/latest/miniconda.html)
    *   **Installation Tip:** During Conda setup, **check the box to "Add Anaconda to my PATH"**.
        This makes running commands easier. If not, use the "Anaconda Prompt".
    *   A PC restart might be needed after Conda installation.

*   **Microsoft C++ Build Tools:** **Required** for some Python packages.
    *   **Download:**
        1.  Go to Visual Studio Downloads: [https://visualstudio.microsoft.com/downloads/](https://visualstudio.microsoft.com/downloads/)
        2.  Scroll to "Tools for Visual Studio" and find "Build Tools for Visual Studio" (e.g., 2022). Download its installer.
    *   **Installation:**
        1.  Run the installer.
        2.  In the "Workloads" tab, select "**Desktop development with C++**".
        3.  On the right "Installation details" pane, ensure these are checked:
            *   "MSVC v14x - VS 20xx C++ x64/x86 build tools (Latest)"
            *   "Windows 10 SDK" (or latest Windows SDK)
        4.  Click "Install". This may take time and disk space.
        5.  A PC restart might be needed.
    *   *Note: If you have Visual Studio with "Desktop development with C++" already, you're likely set.*

*   **Internet Connection:** Needed for downloads (Conda, Build Tools, Python packages, and the TTS model on first app run).

---

## 2. Setup Instructions - Getting Ready

1.  **Download & Extract:**
    *   Get the project ZIP (e.g., `Chatterbox-TTS-GGUF-Fixed.zip`).
    *   Extract it to a convenient folder (e.g., `C:\Projects\resemble-ai`).
    *   Open this `resemble-ai` folder.

2.  **Run Environment Setup Script:**
    *   Inside the `resemble-ai` folder, double-click `setup_environment.bat`.
    *   A command window will open. This script creates a Conda environment
        (named `chatterbox-env-distro` or similar) and installs all dependencies.
    *   This step can take a while. Follow any on-screen prompts.
    *   The window will pause when done ("Setup Complete!"); you can then close it.

3.  **Run Chatterbox TTS Application:**
    *   After successful setup, double-click `run-ggc-chatterbox.bat` (in the same `resemble-ai` folder).
    *   **Two Command Windows Will Appear:**
        1.  **Window 1 (Launcher):** Briefly shows setup of variables and patches.
        2.  **Window 2 (Server):** This is the main application window. It shows logs for the
            Chatterbox server, including model loading and web activity.
            **Keep Window 2 open while using the app.**
    *   **Automatic Model Download (First Run):**
        *   The first time you run the app, it will automatically download the necessary
            GGUF model (e.g., `calcuis/chatterbox-gguf`).
        *   Watch for download progress in **Window 2**. This can take time.
        *   Subsequent runs will be faster as the model will be cached.
    *   **Access the Web UI:**
        *   Once Window 2 shows "Running on local URL: http://127.0.0.1:7860" (or similar),
            open your web browser and go to `http://127.0.0.1:7860`.

---

## 3. Important Notes

*   **Model Download Location:** The GGUF model usually downloads to a cache directory
    (e.g., `C:\Users\YourUserName\.cache\gguf-connector`).
*   **`ggc c2` Command:** The `run-ggc-chatterbox.bat` uses `ggc c2`. This command handles
    model downloading and loading, relying on your `chichat` installation and its profiles.

---

## 4. Troubleshooting

#### During Setup (`setup_environment.bat`):

*   **"Conda is not found"**:
    *   Ensure Conda is installed and added to your system PATH.
    *   Try restarting your PC after Conda installation.
*   **Errors like "Microsoft Visual C++ 14.0 or greater is required"**:
    *   This means Microsoft C++ Build Tools are missing or not correctly set up.
        Please carefully re-check Prerequisite #1.2.
*   **Other `pip install` or `conda env create` errors**:
    *   Check your internet connection.
    *   Note the specific error. There might be temporary issues with package servers.
    *   Ensure sufficient disk space.
*   **"Environment already exists"**:
    *   The script detected an existing environment with the same name.
    *   For a fresh install, manually remove it: `conda env remove -n chatterbox-env-distro`
        (replace with your environment name), then re-run `setup_environment.bat`.

#### During Application Run (`run-ggc-chatterbox.bat`):

*   **Window 1 closes, Window 2 doesn't appear or closes quickly**:
    *   The environment activation (`conda activate ...`) might have failed. Ensure setup was successful.
    *   Check Window 1 for Python errors (if it closes too fast, run `run-ggc-chatterbox.bat`
        from an already open Anaconda Prompt to see all messages).
*   **Model Download Issues (seen in Window 2)**:
    *   Verify your internet connection is stable.
    *   Look for error messages from `gguf-connector` or `chichat` in Window 2.
*   **Application errors after download (seen in Window 2)**:
    *   Consult error messages in Window 2.
*   **Performance Issues**:
    *   The CPU optimization settings in `run-ggc-chatterbox.bat` are defaults.
        You might need to adjust them for different CPUs.

---

## 5. Stopping the Application

*   To stop Chatterbox TTS, go to **Window 2** (the server log window).
*   Press `Ctrl+C`. You might need to confirm by pressing `Y` or `Ctrl+C` again.
*   Closing Window 2 will terminate the application. Window 1 can then also be closed.


---

## 6. Uninstalling Chatterbox TTS

If you wish to remove the Chatterbox TTS setup:

1.  Navigate to the project folder (e.g., `resemble-ai/`).
2.  Double-click the `uninstall_ggc-chatterbox.bat` script.
3.  This script will guide you through:
    *   Removing the Conda environment (`chatterbox-env-distro`).
    *   Instructions for manually clearing any cached GGUF models.
4.  After running the uninstaller, if you want to remove all project files,
    you can then manually delete the entire `resemble-ai/` project folder.



