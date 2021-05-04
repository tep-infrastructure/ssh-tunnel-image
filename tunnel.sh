#!/bin/bash

echo "In port: $IN_PORT"
echo "Out server: $OUT_SERVER"
echo "Out port: $OUT_PORT"
echo "Target: $TARGET"
echo "PEM path: $PEM_PATH"

ls -ll $PEM_PATH
cp $PEM_PATH tunnel.pem
chmod 400 tunnel.pem

ssh -vvv -o StrictHostKeyChecking=no \
    -o ServerAliveInterval=60 \
    -o ExitOnForwardFailure=yes \
    -N -R $IN_PORT:$OUT_SERVER:$OUT_PORT -i tunnel.pem $TARGET
