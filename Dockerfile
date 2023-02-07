FROM ubuntu:latest

RUN apt-get update -y

RUN echo "sleeping for a day"

CMD ["sh", "-c", "sleep 1d"]
