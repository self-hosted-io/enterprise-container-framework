FROM mbern/builda:1.0.0
RUN dnf update -y && dnf install -y python3-pip
WORKDIR /build
ADD . /build/
RUN pip3 install -r requirements.txt
RUN mkdocs build

FROM nginx:latest as final
RUN rm -rf /etc/nginx/conf.d/*
RUN rm -rf /usr/share/nginx/html/*
COPY --from=0 /build/site /usr/share/nginx/html
ADD nginx.conf /etc/nginx/conf.d/default.conf