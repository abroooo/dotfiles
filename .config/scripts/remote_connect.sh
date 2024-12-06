#!/bin/sh

# Start a vpn service using gp open connect with SAML support
#The vpn command defaults to a podman proxyfied connectio


COMMAND="podman run -it --rm -p 1080:1080 vpn"
# COMMAND="openconnect"
DOMAIN=$REMOTE_CONNECT_DOMAIN

SAML_PARSER="gp-saml-gui --allow-insecure-crypto --no-verify --gateway"

echo "Starting openconnect\n"

#Do a gp connection
eval $( $SAML_PARSER $DOMAIN) 2> /dev/null
echo $HOST
echo $COOKIE
echo $USER
echo "Recieved cookie information\n"

# Start the container in detatched mode
#Connect using new parameters
echo $COOKIE | $COMMAND -v --protocol=gp '--useragent=PAN GlobalProtect' -u $USER --passwd-on-stdin $HOST
