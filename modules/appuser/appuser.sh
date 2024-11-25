#!/bin/bash

set -eux

# i like the devil, he's my mate.
groupadd -r appuser -g 666 && useradd -u 666 -r -g appuser -m -d /opt/app_env -s /sbin/nologin -c "Non-root user to run apps with" appuser
