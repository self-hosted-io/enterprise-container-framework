from fastapi import FastAPI
import logging
import os

# import lifespan event from app_init
#from onboarder_github_fastapi.internal.app_init import init_func

# import internal healthcheck
from internal.healthcheck import router as healthcheck_router

# import internal create_github_repo
from internal.create_github_repo import router as create_github_repo_router

# import internal failed_jobs
from internal.failed_jobs import router as failed_jobs_router



# setup logging
logger = logging.getLogger(__name__)
logger.setLevel(os.environ.get("LOG_LEVEL", "INFO"))

# create FastAPI app object with app_init
app = FastAPI()

# include healthcheck router
app.include_router(healthcheck_router)

# include create_github_repo router
app.include_router(create_github_repo_router)

# include failed_jobs router
app.include_router(failed_jobs_router)


@app.on_event("startup")
async def startup_event():
    # run init_func
    logger.info("Application Init Lifespan has completed")
