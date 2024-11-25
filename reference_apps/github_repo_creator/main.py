from fastapi import FastAPI
from contextlib import asynccontextmanager
import logging



logger = logging.getLogger(__name__)

@asynccontextmanager
async def init(app: FastAPI):
    logging.info("Initializing app")

app = FastAPI(init=init)

@app.get("/")
async def root():
    logger.info(f"request / endpoint!")
    return {"message": "hello world"}

@app.post("/create_repo")
async def create_repo():
    logger.info(f"request /create_repo endpoint!")
    return {"message": "repo created"}