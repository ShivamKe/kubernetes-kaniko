FROM ubuntu:latest

RUN apt-get update -y

CMD ["sh", "-c", "tail -f /dev/null"]
