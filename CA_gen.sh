# = Setup of CA and certificates = (Credits to: https://www.rabbitmq.com/ssl.html)

# Ask the user for the name of the CA
echo -n "Enter the name of your CA: "
read CA_name
echo "You entered: $CA_name"

# Ask the user for the hostname
echo "[i] Enter the name of your host (important, this will be the hostname to be used in the certificates to identify the server)\n"
echo -n "Hostname: "
read CA_hostname
echo "You entered: $CA_hostname"

# Ask the user for the password of client certificate
echo "[i] Enter the password to be used for the client certificates\n"
echo -n "Client certificate password: "
read CA_client_cert_password
echo "You entered: $CA_client_cert_password"

# Ask the user for the password of client certificate
echo "[i] Enter the password to be used for the server certificates\n"
echo -n "Server certificate password: "
read CA_server_cert_password
echo "You entered: $CA_server_cert_password"

# == Setup of directories ==

if [ -d $CA_name"_CA_files" ]; then
    echo "Directory "$CA_name"_CA_files exists."
    exit
fi
mkdir $CA_name"_CA_files"
cd $CA_name"_CA_files"
# All files inside that main folder.
mkdir $CA_name
cd $CA_name
mkdir certs private
chmod 700 private
echo 01 > serial
touch index.txt

# == Setup of the openssl.cnf ==

echo "[ ca ]
default_ca = $CA_name

[ $CA_name ]
dir = .
certificate = \$dir/cacert.pem
database = \$dir/index.txt
new_certs_dir = \$dir/certs
private_key = \$dir/private/cakey.pem
serial = \$dir/serial

default_crl_days = 7
default_days = 365
default_md = sha1

policy = "$CA_name"_policy
x509_extensions = certificate_extensions

[ "$CA_name"_policy ]
commonName = supplied
stateOrProvinceName = optional
countryName = optional
emailAddress = optional
organizationName = optional
organizationalUnitName = optional

[ certificate_extensions ]
basicConstraints = CA:false

[ req ]
default_bits = 2048
default_keyfile = ./private/cakey.pem
default_md = sha1
prompt = yes
distinguished_name = root_ca_distinguished_name
x509_extensions = root_ca_extensions

[ root_ca_distinguished_name ]
commonName = hostname

[ root_ca_extensions ]
basicConstraints = CA:true
keyUsage = keyCertSign, cRLSign

[ client_ca_extensions ]
basicConstraints = CA:false
keyUsage = digitalSignature
extendedKeyUsage = 1.3.6.1.5.5.7.3.2

[ server_ca_extensions ]
basicConstraints = CA:false
keyUsage = keyEncipherment
extendedKeyUsage = 1.3.6.1.5.5.7.3.1" > openssl.cnf

# == Generate key and certificates to be used with the CA ==

openssl req -x509 -config openssl.cnf -newkey rsa:2048 -days 365 -out cacert.pem -outform PEM -subj /CN=$CA_name/ -nodes
openssl x509 -in cacert.pem -out cacert.cer -outform DER

# == Create server certificates ==

cd ..
mkdir server
cd server
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=$CA_hostname/O=server/ -nodes
cd ../$CA_name
openssl ca -config openssl.cnf -in ../server/req.pem -out ../server/cert.pem -notext -batch -extensions server_ca_extensions
cd ../server
openssl pkcs12 -export -out keycert.p12 -in cert.pem -inkey key.pem -passout pass:$CA_server_cert_password

# == Create client certificates ==

cd ..
mkdir client
cd client
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=$CA_hostname/O=client/ -nodes
cd ../$CA_name
openssl ca -config openssl.cnf -in ../client/req.pem -out ../client/cert.pem -notext -batch -extensions client_ca_extensions
cd ../client
openssl pkcs12 -export -out keycert.p12 -in cert.pem -inkey key.pem -passout pass:$CA_client_cert_password
