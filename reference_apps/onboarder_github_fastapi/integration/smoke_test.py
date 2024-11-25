## pytest test_onboarder.py
## this script runs the integration tests for the onboarder app against a docker container

import requests
import time
import os

# get host ip address
host_ip = os.popen("hostname -I").read().split()[0]
print("host ip: ", host_ip)

# setup the base_url var, if the env CI=true, use the container name, else use localhost
if os.getenv("CI") == "true":
    base_url = "http://localhost:8080"
else:
    base_url = "http://" + host_ip + ":8080"

# set endpoint urls
healthcheck = base_url + "/healthcheck"
deep_healthcheck = base_url + "/deepcheck"

# check if the onboarder app is running prior to running tests, check 30 times with 1 second interval
def check_app():
    for i in range(30):
        try:
            response = requests.get(healthcheck)
            if response.status_code == 200:
                return True
        except requests.exceptions.RequestException as e:
            print(e)
        time.sleep(1)
    return False


## assert healthcheck endpoint returns 200
def test_healthcheck():
    try:
        response = requests.get(healthcheck)
        assert response.status_code == 200
    except requests.exceptions.RequestException as e:
        print(e)
        assert False

## assert deepcheck endpoint returns 200 and the following JSON response:
#{
#  "server": "healthy",
#  "redis": "healthy"
#}
def test_deepcheck():
    try:
        response = requests.get(deep_healthcheck)
        assert response.status_code == 200
        assert response.json() == {"server": "healthy", "redis": "healthy"}
    except requests.exceptions.RequestException as e:
        print(e)
        assert False