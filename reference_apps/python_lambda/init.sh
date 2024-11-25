docker run --platform linux/amd64 \
-d -v ~/.aws-lambda-rie:/aws-lambda \
-p 9000:8080 \
--entrypoint /aws-lambda/aws-lambda-rie \
-e AWS_ACCESS_KEY_ID=foo \
-e AWS_SECRET_ACCESS_KEY=bar \
-e AWS_SESSION_TOKEN=baz \
mbern/lb:test         \
/usr/local/bin/python3 -m awslambdaric lambda_function.handler