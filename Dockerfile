FROM moby/buildkit:master-rootless

LABEL org.opencontainers.image.source=https://github.com/gantrycd/image-builder

USER root

RUN apk add --no-cache \
    git \
    bash


WORKDIR /app

COPY build.sh /app/build.sh
COPY buildctl-daemonless.sh /app/buildctl-daemonless.sh

RUN chown -R 1000:1000 /app
RUN chmod +x /app/build.sh /app/buildctl-daemonless.sh
USER 1000:1000

ENTRYPOINT ["/app/build.sh"]