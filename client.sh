#!/usr/bin/env bash

curl -v --cacert ca/cert.pem \
    --cert client/cert.pem \
    --key client/key.pem \
    https://localhost:8443/hello
