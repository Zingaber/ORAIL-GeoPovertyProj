try:
    import langchain
    import openai
    import torch
    import transformers

    print("✅ LangChain, OpenAI, Torch, and Transformers are successfully imported.")
    print(f"Torch CUDA available: {torch.cuda.is_available()}")
    print(f"Transformers version: {transformers.__version__}")

except ImportError as e:
    print(f"❌ Import failed: {e}")
