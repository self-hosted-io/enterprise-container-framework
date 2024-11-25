# this is a fastapi endpoint that returns a 200 status code if the service is healthy

from fastapi import APIRouter
import redis
import os

import logging

# setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter()

r = redis.Redis(host=os.environ.get('REDIS_HOST'), port=os.environ.get('REDIS_PORT'), db=0)

@router.get("/healthcheck", tags=["System"])
async def healthcheck():
    # check if redis is up
    try:
        r.ping()
        return {"status": "up"}
    except Exception as e:
        return {"status": "down", "error": str(e)}
    
@router.get("/deepcheck", tags=["System"])
async def deepcheck():
    logger.info("Deep check started")
    # check if redis is up
    try:
        r.ping()
        # return 200, healthy and redis status as json
        return {"server": "healthy", "redis": "healthy"}
    except Exception as e:
        return {"server": "down", "error": str(e)}