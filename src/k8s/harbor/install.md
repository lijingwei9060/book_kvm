
## tls certificate
```shell
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=MyPersonal Root CA" \
 -key ca.key \
 -out ca.crt

openssl genrsa -out 10.16.161.21.nip.io.key 4096

openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=10.16.161.21.nip.io" \
 -key 10.16.161.21.nip.io.key \
 -out 10.16.161.21.nip.io.crt


cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=10.16.161.21.nip.io
DNS.2=10.16.161.21.nip.io
DNS.3=10.16.161.21
EOF


openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in 10.16.161.21.nip.io.csr \
    -out 10.16.161.21.nip.io.crt


openssl x509 -inform PEM -in 10.16.161.21.nip.io.crt -out 10.16.161.21.nip.io.cert
```