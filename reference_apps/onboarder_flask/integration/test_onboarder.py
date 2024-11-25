## pytest test_onboarder.py
## this script runs the integration tests for the onboarder app against a docker container

import requests
import time


# confgure base url for local or remote testing
base_url = "http://localhost:8000"

# set endpoint urls
healthcheck = base_url + "/health"

# set system overview endpoint
system_overview = base_url + "/system"

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

def test_system_overview():
    try:
        response = requests.get(system_overview)
        assert response.status_code == 200
        assert 'python_version' in response.json()
        assert 'flask_version' in response.json()
    except requests.exceptions.RequestException as e:
        print(e)
        assert False


