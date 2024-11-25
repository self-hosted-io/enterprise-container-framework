@mbern/builda

Feature: Pip Dev Tools
    Scenario: check the container has mkdocs installed
        When container is started with command bash
        Then run mkdocs --version in container and check its output contains mkdocs
