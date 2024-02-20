FROM docker:dind

USER root
RUN addgroup -S builder && adduser -S -G builder builder

RUN apk add --no-cache \
    git \
    bash

WORKDIR /app

COPY build.sh /app/build.sh

RUN chmod +x /app/build.sh

ENTRYPOINT ["/app/build.sh"]