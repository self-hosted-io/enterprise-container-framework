## pytest test_onboarder.py
## this script runs the integration tests for the onboarder app against a docker container

import requests
import time
import


# confgure base url for local or remote testing
base_url = "http://localhost:8080"

# set endpoint urls
healthcheck = base_url + "/healthcheck"

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