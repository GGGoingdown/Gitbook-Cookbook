from fastapi import FastAPI
from src import __VERSION__

print(f"Version: {__VERSION__}")

app = FastAPI(
    version=__VERSION__,
)


@app.get("/health")
def health():
    return {"status": "ok"}



