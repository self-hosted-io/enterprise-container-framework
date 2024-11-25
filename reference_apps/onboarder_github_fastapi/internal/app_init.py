from contextlib import asynccontextmanager
from fastapi import FastAPI
import redis

import logging
import os

# this is a FastAPI lifespan event that runs when the application starts

# setup logging
logger = logging.getLogger(__name__)
logger.setLevel(os.environ.get("LOG_LEVEL", "INFO"))

# init_func, this function checks all the environment variables that are required for the application to run
def init_func():
    # check if REDIS_HOST is set
    if os.environ.get('REDIS_HOST') is None:
        logger.error("REDIS_HOST is not set")
        raise Exception("REDIS_HOST is not set")

    # check if REDIS_PORT is set
    if os.environ.get('REDIS_PORT') is None:
        logger.error("REDIS_PORT is not set")
        raise Exception("REDIS_PORT is not set")

    # check if GITHUB_REPO_CREATOR_TOKEN is set
    if os.environ.get('GITHUB_REPO_CREATOR_TOKEN') is None:
        logger.error("GITHUB_REPO_CREATOR_TOKEN is not set")
        raise Exception("GITHUB_REPO_CREATOR_TOKEN is not set")
    
    # return True if all checks pass
    return True

