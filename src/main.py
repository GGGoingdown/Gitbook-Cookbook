from fastapi import FastAPI
from src import __VERSION__

print(f"Version: {__VERSION__}")

app = FastAPI(
    version=__VERSION__,
)

@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/health")
def health():
    return {"status": "ok"}



