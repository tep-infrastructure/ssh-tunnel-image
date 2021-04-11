#!/bin/bash

TOKEN=$(curl --insecure --silent \
    --request POST \
    --data "{ \"password\": \"${VAULT_PASSWORD}\" }" \
    "https://vault.internal/v1/auth/userpass/login/$VAULT_USERNAME" \
    | jq -r '.auth.client_token' )

RESPONSE_CODE=$(curl --insecure --silent -H "X-Vault-Token: ${TOKEN}" -o /dev/null -w "%{http_code}" ${VAULT_PATH})

if [[ "$RESPONSE_CODE" -ne "200" ]]
then
    echo "Invalid response getting token: $RESPONSE_CODE"
    exit 1
fi

curl --insecure -v \
    -H "X-Vault-Token: ${TOKEN}" \
    ${VAULT_PATH}

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

ssh -vvvvv -o StrictHostKeyChecking=no \
    -o ServerAliveInterval=60 \
    -o ExitOnForwardFailure=yes \
    -N -R $IN_PORT:$OUT_SERVER:$OUT_PORT -i tunnel.pem $TARGET
