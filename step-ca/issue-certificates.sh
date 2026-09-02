#!/bin/sh

set -eu

ca_url=https://step-ca:9000
root_certificate=/step-ca/certs/root_ca.crt
domains_file=/config/domains.txt
certificate=/certs/local-dev.crt
private_key=/certs/local-dev.key
primary_domain=

set --

while IFS= read -r line || [ -n "$line" ]; do
    domain=$(printf '%s' "$line" | sed 's/#.*//; s/[[:space:]]//g')

    [ -z "$domain" ] && continue

    case "$domain" in
        *[!a-zA-Z0-9.-]* | .* | *.)
            echo "Invalid domain in $domains_file: $domain" >&2
            exit 1
            ;;
    esac

    if [ -z "$primary_domain" ]; then
        primary_domain=$domain
    fi

    set -- "$@" --san "$domain" --san "*.$domain"
done < "$domains_file"

if [ -z "$primary_domain" ]; then
    echo "Add at least one domain to $domains_file." >&2
    exit 1
fi

step ca certificate \
    "$primary_domain" \
    "$certificate" \
    "$private_key" \
    "$@" \
    --not-after=8760h \
    --force \
    --ca-url "$ca_url" \
    --root "$root_certificate" \
    --provisioner admin \
    --provisioner-password-file /step-ca/secrets/password

cp "$root_certificate" /certs/local-root-ca.crt

echo "Issued $certificate for the domains in $domains_file"
