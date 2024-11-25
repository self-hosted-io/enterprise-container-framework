@mbern/base-os

Feature: Trust items are installed

    Scenario: check the container has openssl installed
        When container is started with command bash
        Then run openssl version in container and check its output contains OpenSSL
