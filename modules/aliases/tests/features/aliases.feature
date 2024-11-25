@mbern/python-ent-3.10
@mbern/python-ent-3.11
@mbern/python-ent-3.12

Feature: Ensure python is an alias for python3

    Scenario: Python alias
        When container is started with command bash
        Then run python --version in container and check its output contains Python 3
        Then run bash -c 'echo $PYTHON_VERSION' in container and check its output contains 3