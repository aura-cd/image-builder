FROM alpine:latest

RUN apk add --no-cache \
    git \
    docker-cli \
    bash

WORKDIR /app

COPY build.sh /app/build.sh

RUN chmod +x /app/build.sh

CMD ["/app/build.sh"]
