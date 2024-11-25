@mbern/python-ent-3.10
@mbern/python-ent-3.11
@mbern/python-ent-3.12

Feature: Test appuser is created and not

Scenario: check the container runs with the user appuser
    When container is started with command bash
    Then run whoami in container and check its output contains appuser