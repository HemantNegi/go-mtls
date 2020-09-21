#!/usr/bin/env bash
# If you are getting the error “Error Loading extension section v3_ca” using macOS on step 2,
# add the following to your /etc/ssl/openssl.cnf
# [ v3_ca ]
# basicConstraints = critical,CA:TRUE
# subjectKeyIdentifier = hash
# authorityKeyIdentifier = keyid:always,issuer:always

mkdir ca server client

echo Generate the ca key
openssl genrsa -out ca/key.pem 4096

echo Generate the ca certificate
openssl req -x509 -sha256 -new -nodes -key ca/key.pem -days 3650 \
      -subj "/C=IN/ST=UK/L=Dehradun/O=VMware/CN=Hemant Root CA" \
      -extensions v3_ca \
      -out ca/cert.pem


echo generating server certificate
openssl genrsa -out server/key.pem 2048
openssl req -new \
      -subj "/C=IN/ST=UK/L=Dehradun/O=VMware/CN=localhost" \
      -key server/key.pem \
      -out server/signingReq.csr
openssl x509 -req -days 365 -in server/signingReq.csr -CA ca/cert.pem -CAkey ca/key.pem -CAcreateserial -out server/cert.pem
rm server/signingReq.csr

# verify cert
openssl verify -CAfile ca/cert.pem server/cert.pem


echo generating client certificate
openssl genrsa -out client/key.pem 2048
openssl req -new \
      -subj "/C=IN/ST=UK/L=Dehradun/O=VMware/CN=localhost" \
      -key client/key.pem \
      -out client/signingReq.csr
openssl x509 -req -days 365 -in client/signingReq.csr -CA ca/cert.pem -CAkey ca/key.pem -CAcreateserial -out client/cert.pem
rm client/signingReq.csr

# verify cert
openssl verify -CAfile ca/cert.pem client/cert.pem
