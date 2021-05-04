# SSH Tunnel Image

A Docker image to open an SSH tunnel to a remote server.

A container will need the following for environment variables:

| env variable | Description |
|--------------|-------------|
| TARGET       | The server the tunnel should connect to. This server will be public endpoint that other clients will be sending web traffic to. For AWS endpoints this should include the user, eg `ec2-user@public_dns`. Note this needs to be public DNS, the public IP will not work.
| IN_PORT      | The port the tunnel should listen on. |
| OUT_SERVER   | The server the tunnel should send traffic to. |
| OUT_PORT     | The port the tunnel should send traffic to. |
| PEM_PATH     | The file path of the PEM file to make an SSH connection to the TARGET server. This path could either point to a volume or to a file path on a derived container. Note that it will be copied at runtime to better handle readonly volumes. |
