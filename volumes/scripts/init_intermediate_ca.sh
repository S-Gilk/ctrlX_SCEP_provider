cat << EOF > rsa_root_ca.tpl
{
  "subject": {{ toJson .Subject }},
  "issuer": {{ toJson .Subject }},
  "keyUsage": ["certSign", "crlSign"],
  "basicConstraints": {
    "isCA": true,
    "maxPathLen": 1
  }
  {{- if typeIs "*rsa.PublicKey" .Insecure.CR.PublicKey }}
    , "signatureAlgorithm": "SHA256-RSAPSS"
  {{- end }}
}
EOF

cat << EOF > rsa_intermediate_ca.tpl
{
  "subject": {{ toJson .Subject }},
  "issuer": {{ toJson .Subject }},
  "keyUsage": ["certSign", "crlSign","keyEncipherment","dataEncipherment"],
  "basicConstraints": {
    "isCA": true,
    "maxPathLen": 0
  }
  {{- if typeIs "*rsa.PublicKey" .Insecure.CR.PublicKey }}
    , "signatureAlgorithm": "SHA256-RSAPSS"
  {{- end }}
}
EOF

step certificate create "Rexroth Root CA" \
    $(step path)/certs/root_ca.crt \
    $(step path)/secrets/root_ca_key \
    --template rsa_root_ca.tpl \
    --kty RSA \
    --not-after 87660h \
    --size 3072 \
	--password-file $(step path)/secrets/password \
	--ca-password-file $(step path)/secrets/password \
    --force
step certificate create "Rexroth Intermediate CA" \
    $(step path)/certs/intermediate_ca.crt \
    $(step path)/secrets/intermediate_ca_key \
    --ca $(step path)/certs/root_ca.crt \
    --ca-key $(step path)/secrets/root_ca_key \
    --template rsa_intermediate_ca.tpl \
    --kty RSA \
    --not-after 87660h \
    --size 3072 \
	--password-file $(step path)/secrets/password \
	--ca-password-file $(step path)/secrets/password \
    --force
	