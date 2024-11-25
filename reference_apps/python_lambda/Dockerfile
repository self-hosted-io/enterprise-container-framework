ARG BASE_IMAGE=mbern/python-ent-lambda-3.10:latest
FROM $BASE_IMAGE
COPY . /opt/app_env
RUN pip3 install -r /opt/app_env/requirements.txt
ENTRYPOINT [ "python3", "-m", "awslambdaric" ]
CMD [ "lambda_function.handler" ]
 
