@echo off
echo Activating conda environment...
call conda activate chatterbox-tts-env

echo Setting CPU optimization for i5-1235U...
REM Hybrid architecture optimization
set MKL_THREADING_LAYER=GNU
set OMP_NUM_THREADS=6
set MKL_NUM_THREADS=6
set KMP_DUPLICATE_LIB_OK=TRUE

REM CPU-specific optimizations
set MKL_DYNAMIC=FALSE
set OMP_DYNAMIC=FALSE
set OMP_PROC_BIND=true
set OMP_PLACES=cores
set OMP_SCHEDULE=static

REM Memory settings
set MALLOC_TRIM_THRESHOLD_=100000

REM Gradio/HTTP settings to prevent errors
set GRADIO_SERVER_PORT=7860
set GRADIO_SERVER_NAME=127.0.0.1
set GRADIO_ANALYTICS_ENABLED=False
set UVICORN_LOG_LEVEL=warning

REM GGUF CPU settings
set GGML_METAL=0
set GGML_CUDA=0
set GGML_OPENCL=0

REM Suppress warnings
set TRANSFORMERS_VERBOSITY=error
set TOKENIZERS_PARALLELISM=false

echo Environment optimized for CPU processing
echo Applying fixes...
python chatterbox_fix.py
python gradio_patch.py

echo Starting chatterbox...
start /high ggc c2
pause