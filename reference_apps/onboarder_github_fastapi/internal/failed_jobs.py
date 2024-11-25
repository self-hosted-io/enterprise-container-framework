from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import logging
import redis
import os

# setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter()

# setup redis connection
r = redis.Redis(host=os.environ.get('REDIS_HOST'), port=os.environ.get('REDIS_PORT'), db=0)

@router.get("/rest/api/github/repo/failed_jobs", tags=["Github Job Status"])
async def get_failed_jobs():
    # get all keys from redis
    keys = r.keys()

    # loop through all keys and get get those with status failed
    failed_jobs = []
    for key in keys:
        if r.get(key).decode('utf-8') == "failed":
            failed_jobs.append(key.decode('utf-8'))


    return failed_jobs

@router.get("/rest/api/github/repo/successful_jobs", tags=["Github Job Status"])
async def get_successful_jobs():
    # get all keys from redis
    keys = r.keys()

    # loop through all keys and get get those with status failed
    successful_jobs = []
    for key in keys:
        if r.get(key).decode('utf-8') == "success":
            successful_jobs.append(key.decode('utf-8'))


    return successful_jobs

