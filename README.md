# Web^ID Localhost Certificate Authority

Use this repository's CA root certificate on your computer to make our localhost subdomains to work properly on each Web^Ids projects.

## How to use?

To install it on macOS :

```bash
mkdir ~/certs -p
cd ~/certs
curl -o ./webid-localhost-CA.pem https://raw.githubusercontent.com/web-id-fr/web-id-localhost-ca/refs/heads/main/certs/webid-localhost-CA.pem
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" webid-localhost-CA.pem
```

## Generate a new project wildcard certificate

To generate a new project wildcard certificate that is recognised by our CA root certificate, use this bash script:

_(You will need to know the passphrase of our CA root certificate beforehand)_

```bash
./create-project-wildcard-certificate.sh
```