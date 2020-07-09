export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

vault auth enable approle

cat << EOF > webapp-pol.hcl
path "secret/data/mysql/*" {
  capabilities = [ "read" ]
}
EOF
vault policy write webapp webapp-pol.hcl


vault write auth/approle/role/webapp \
    token_policies="webapp" \
    secret_id_num_uses=10 \
    token_ttl=1h token_max_ttl=4h

## Reading the role settings.
vault read auth/approle/role/webapp


## Read the role ID. The role ID is static.
echo ""
echo ">>>> vault read auth/approle/role/webapp/role-id"
vault read auth/approle/role/webapp/role-id