#!/bin/sh

set -eu

ca_config=/home/step/config/ca.json

# Local development certificates should not expire every 24 hours. Running
# this on every start also applies the setting to an existing CA.
step ca provisioner update admin \
    --x509-min-dur=5m \
    --x509-max-dur=8760h \
    --x509-default-dur=8760h \
    --ca-config "$ca_config"

exec step-ca "$ca_config" --password-file /home/step/secrets/password
