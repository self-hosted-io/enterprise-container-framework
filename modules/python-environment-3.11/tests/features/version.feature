@mbern/python-ent-3.11

Feature: Installed Python Version

    Scenario: Python version is 3.11
        When container is started with command bash
        Then run python3 --version in container and check its output contains Python 3.11
        Then run bash -c 'echo $PYTHON_VERSION' in container and check its output contains 3.11