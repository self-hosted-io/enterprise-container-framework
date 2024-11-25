@mbern/python-ent-3.13

Feature: Python Pip

    Scenario: Python Pip is installed
        When container is started with command bash
        Then run pip --version in container and check its output contains pip 24
