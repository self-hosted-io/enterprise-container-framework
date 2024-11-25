@mbern/python-ent-3.10
@mbern/python-ent-3.11
@mbern/python-ent-3.12

Feature: Test dumb init is installed 

    Scenario: check the container runs with the user root
        When container is started with command bash
        Then run /usr/local/bin/dumb-init --version in container and check its output contains 1.2.5