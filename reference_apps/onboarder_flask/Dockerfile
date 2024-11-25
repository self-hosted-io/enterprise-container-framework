# FROM BUILD_ARG is the base image for the container
ARG BASE_IMAGE=mbern/python-ent-3.11:1.0.0
FROM $BASE_IMAGE
ADD . /opt/app_env
RUN pip3 install -r /opt/app_env/requirements.txt
CMD [ "gunicorn", "-c", "python:config", "main:app" ]
