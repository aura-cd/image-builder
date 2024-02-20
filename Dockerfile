FROM docker:dind

LABEL org.opencontainers.image.source=https://github.com/gantrycd/image-builder

USER root
RUN addgroup -S builder && adduser -S -G builder builder

RUN apk add --no-cache \
    git \
    bash

WORKDIR /app

COPY build.sh /app/build.sh

RUN chmod +x /app/build.sh

ENTRYPOINT ["/app/build.sh"]