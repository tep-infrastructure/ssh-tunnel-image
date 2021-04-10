FROM ubuntu

# the port to bind to on the remote server. connections to this port
# on remote will be tunnelled
ARG in_port=8888

# the server to send tunnelled traffic
ARG out_server=tomserver

# the port to send tunnelled traffic
ARG out_port=80

# the user and address of the remote server
ARG target=

ENV in_port=${in_port}
ENV out_server=${out_server}
ENV out_port=${out_port}
ENV target=${target}

RUN apt -y update
RUN apt -y install openssh-client
COPY tunnel.pem tunnel.pem
RUN chmod 400 tunnel.pem
ENTRYPOINT ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -N -R $in_port:$out_server:$out_port -i tunnel.pem $target
