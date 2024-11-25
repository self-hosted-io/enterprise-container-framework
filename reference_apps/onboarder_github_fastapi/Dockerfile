ARG BASE_IMAGE=mbern/python-ent-3.10:latest
FROM $BASE_IMAGE
ADD . /opt/app_env
RUN pip3 install -r /opt/app_env/requirements.txt
CMD [ "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080", "--log-config=log_conf.yaml", "--use-colors" ]
EXPOSE 8080
#HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl --fail http://localhost:8080/healthcheck || exit 1