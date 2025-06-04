import os
import warnings

# Suppress warnings
warnings.filterwarnings("ignore", category=FutureWarning)
warnings.filterwarnings("ignore", category=UserWarning)

# Set environment variables
os.environ['TRANSFORMERS_VERBOSITY'] = 'error'
os.environ['TOKENIZERS_PARALLELISM'] = 'false'
os.environ['GRADIO_ANALYTICS_ENABLED'] = 'False'

# Fix for model loading
def patch_model_loading():
    try:
        import transformers
        from transformers import AutoModel, AutoTokenizer
        
        # Monkey patch to use eager attention
        original_from_pretrained = AutoModel.from_pretrained
        
        def patched_from_pretrained(*args, **kwargs):
            if 'attn_implementation' not in kwargs:
                kwargs['attn_implementation'] = 'eager'
            return original_from_pretrained(*args, **kwargs)
        
        AutoModel.from_pretrained = patched_from_pretrained
        print("✓ Model loading patched for CPU compatibility")
        
    except ImportError:
        pass

# Apply patches
patch_model_loading()

print("✓ Chatterbox fixes applied")