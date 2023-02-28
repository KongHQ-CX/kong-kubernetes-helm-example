mkdir ssl-certs/

cd ssl-certs

openssl genrsa -out control-plane-components.key 2048
openssl req -new -key control-plane-components.key -out control-plane-components.csr

cat > control-plane-components.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = manager.example.com
DNS.2 = adminapi.example.com
DNS.3 = portal.example.com
DNS.4 = portalapi.example.com
DNS.5 = api.example.com
EOF

openssl x509 -req -in control-plane-components.csr -out control-plane-components.crt -days 825 -sha256 -extfile control-plane-components.ext -signkey control-plane-components.key
