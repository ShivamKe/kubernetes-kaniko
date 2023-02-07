FROM ubuntu:latest

RUN apt-get update -y

RUN sleep 1d

CMD ["sh", "-c", "sleep 1d"]
