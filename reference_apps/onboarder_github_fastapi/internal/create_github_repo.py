from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import logging
from github import Github
from github import Auth
import redis
import os

# setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# create a new class GithubToken that inherits from BaseModel
class GithubToken(BaseModel):
    token: str

# setup GitHub API
gh_auth = Auth.Token(os.environ.get('GITHUB_REPO_CREATOR_TOKEN'))

# setup GitHub object
gh = Github(auth=gh_auth)

# setup Redis connection
r = redis.Redis(host=os.environ.get('REDIS_HOST'), port=os.environ.get('REDIS_PORT'), db=0)

# need "customfield_10114": "a0091" to get the appid to prefix the repo name
# nened "customfield_10115": "linuxkernel" to get the repo name
# need # {
#   "issue": {
#     "self": "https://bcp-solutions.atlassian.net/rest/api/2/issue/10118
# need the issue key to prefix the repo name

# create a new class JiraHook that inherits from BaseModel
class IssueFields(BaseModel):
    customfield_10114: str
    customfield_10115: str

class Issue(BaseModel):
    self: str
    fields: IssueFields

class JiraHook(BaseModel):
    issue: Issue

class GithubData(BaseModel):
    appid: str
    repo_name: str



router = APIRouter()

# this fast API endpoint creates a new GitHub repository from a data received in this POST request
@router.post("/rest/api/github/repo/create", tags=["Github Repo Creation"])
async def create_github_repo(request: JiraHook):
    # setup object of JiraHook class
    
    jira_hook = JiraHook(**request.model_dump())

    # get issue.fields.customfield_10114 which is the AppID
    appid = jira_hook.issue.fields.customfield_10114

    # get issue.fields.customfield_10115 which is the Repo Name
    repo_name = jira_hook.issue.fields.customfield_10115

    # log the extracted fields
    logger.info(f"Creating a new GitHub repository with appid {appid} and repo name {repo_name}")

    # create a key for Redis
    redis_key = f"{appid}-{repo_name}"
    
    # Check the status in Redis
    status = r.get(redis_key)
    if status:
        status = status.decode('utf-8')
        if status == "success":
            logger.info(f"Repository with appid {appid} and repo name {repo_name} has already been created")
            return {"status": "success", "message": f"Repository with appid {appid} and repo name {repo_name} has already been created"}
        elif status == "pending":
            logger.info(f"Repository with appid {appid} and repo name {repo_name} is already being processed")
            return {"status": "pending", "message": f"Repository with appid {appid} and repo name {repo_name} is already being processed"}
        elif status == "failed":
            logger.info(f"Repository with appid {appid} and repo name {repo_name} has previously failed, retrying...")

    # Try to create the repository
    try:
        r.set(redis_key, "pending")
        gh.get_user().create_repo(f"{appid}-{repo_name}")
    except Exception as e:
        r.set(redis_key, "failed")
        logger.error(f"Failed to create a new GitHub repository: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to create a new GitHub repository: {e}")
    else:
        r.set(redis_key, "success")
        logger.info(f"Successfully created a new GitHub repository with appid {appid} and repo name {repo_name}")
        return {"status": "success", "message": f"Successfully created a new GitHub repository with appid {appid} and repo name {repo_name}"}