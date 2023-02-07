#FROM ubuntu:latest
#RUN apt-get update -y
#RUN apt-get install bash

FROM dockeronce.azurecr.io/node:16.19.0-alpine3.16 as builder
RUN apk update && apk add --no-cache bash \
    jq

# Installing azcopy dependencies
RUN apk --update add --virtual build-dependencies --no-cache wget \
    tar \
    libc6-compat \
    ca-certificates \
    git
# Installing New version of azcopy
RUN wget -O azcopy.tar.gz https://aka.ms/downloadazcopy-v10-linux && \
    tar -xf azcopy.tar.gz && \
    cp azcopy_linux_amd64_10.*/azcopy /usr/bin/ && \
    chmod +x /usr/bin/azcopy

RUN mkdir -p /opt/nginx-entry && \
    mkdir -p /var/www/html
WORKDIR /opt/nginx-entry

FROM builder as adminfrontbuilder

# Installing node modules for admin front
COPY package.json package-lock.json .npmrc /tmp/user-front/
RUN cd /tmp/user-front && npm run clean && npm install

# Copying admin front repository code
RUN mkdir /opt/nginx-entry/io-user-frontend  && \
    cp -a /tmp/user-front/node_modules /opt/nginx-entry/io-user-frontend/
COPY . /opt/nginx-entry/io-user-frontend/

# Copying required scripts
COPY ./docker-scripts /opt/nginx-entry

# Building shared layout for adminFront
RUN cd io-user-frontend && npm run build -- shared-layout --prod

RUN sleep 1d

CMD ["sh", "-c", "sleep 1d"]
