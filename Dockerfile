FROM ubuntu:latest

RUN apt-get update -y

CMD ["sh", "-c", "sleep 1d"]
