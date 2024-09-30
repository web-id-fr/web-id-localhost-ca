#!/bin/bash

# Prompt for the project name (before .localhost)
read -p "Enter the project name (e.g., myproject for *.myproject.localhost): " project

# Define the domain
domain="${project}.localhost"

# Define file names based on the domain
key_file="${domain}.key"
csr_file="${domain}.csr"
ext_file="${domain}.ext"
crt_file="${domain}.crt"

# Generate the private key (without a passphrase)
openssl genrsa -out "$key_file" 2048
echo "Private key generated: $key_file"

# Create a configuration file for the CSR with pre-filled information
cat > "${domain}.csr.conf" <<EOL
[ req ]
default_bits        = 2048
distinguished_name  = req_distinguished_name
prompt              = no

[ req_distinguished_name ]
C  = FR
ST = Auvergne-Rhône-Alpes
L  = Lyon
O  = ${project} Organization
CN = ${domain}
EOL

# Generate the certificate signing request (CSR) using the config file
openssl req -new -key "$key_file" -out "$csr_file" -config "${domain}.csr.conf"
echo "CSR generated: $csr_file"

# Create the extension file for subjectAltName
cat > "$ext_file" <<EOL
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1=${domain}
DNS.2=*.${domain}
EOL

echo "Extension file created: $ext_file"

# Sign the certificate using the CA and generate the final certificate, passing the passphrase
openssl x509 -req -in "$csr_file" -CA certs/webid-localhost-CA.pem -CAkey certs/webid-localhost-CA.key \
-CAcreateserial -out "$crt_file" -days 825 -sha256 -extfile "$ext_file"

echo "Certificate generated: $crt_file"
