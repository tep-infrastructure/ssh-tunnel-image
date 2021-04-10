#!/bin/bash

SECRETS=$(curl --insecure --silent \
    -H "X-Vault-Token: ${TOKEN}" \
    ${VAULT_PATH})

echo "In port: $IN_PORT"
echo "Out server: $OUT_SERVER"
echo "Out port: $OUT_PORT"
echo "Target: $TARGET"

PEM=$( echo ${SECRETS} | jq -r "[.data[].${VAULT_SECRET}][0]" )

echo $PEM | base64 --decode > tunnel.pem
chmod 400 tunnel.pem

ssh -o StrictHostKeyChecking=no \
    -o ServerAliveInterval=60 \
    -o ExitOnForwardFailure=yes
    -N -R $IN_PORT:$OUT_SERVER:$OUT_PORT -i tunnel.pem $TARGET
