import gradio as gr
from functools import wraps
import os

def fix_gradio_responses():
    try:
        # Set Gradio environment variables
        os.environ['GRADIO_ANALYTICS_ENABLED'] = 'False'
        
        # Patch Gradio's launch method to handle content-length issues
        original_launch = gr.Interface.launch
        
        @wraps(original_launch)
        def patched_launch(self, *args, **kwargs):
            # Set safe defaults
            kwargs.setdefault('server_name', '127.0.0.1')
            kwargs.setdefault('server_port', 7860)
            kwargs.setdefault('max_threads', 4)
            kwargs.setdefault('show_error', True)
            
            return original_launch(self, *args, **kwargs)
        
        gr.Interface.launch = patched_launch
        print("✓ Gradio response handling patched")
        
    except Exception as e:
        print(f"Warning: Could not patch Gradio: {e}")

fix_gradio_responses()