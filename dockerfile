FROM ubuntu:20.04

LABEL org.opencontainers.image.source https://github.com/tep-infrastructure/ssh-tunnel-image

# the port to bind to on the remote server. connections to this port
# on remote will be tunnelled
ENV IN_PORT=

# the server to send tunnelled traffic
ENV OUT_SERVER=

# the port to send tunnelled traffic
ENV OUT_PORT=

# the user and address of the remote server
ENV TARGET=

ENV PEM_PATH=

RUN apt-get -y update && apt-get -y install openssh-client

COPY tunnel.sh ./
RUN chmod +x tunnel.sh

ENTRYPOINT ./tunnel.sh
