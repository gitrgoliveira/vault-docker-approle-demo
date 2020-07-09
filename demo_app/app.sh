
VAULT_TOKEN=$(cat /run/secrets/secret_id)

# Unwrap Secret ID
export SECRET_ID=$(curl -s -X PUT -H "X-Vault-Request: true" \
            -H "X-Vault-Token: $VAULT_TOKEN" \
            $VAULT_ADDR/v1/sys/wrapping/unwrap | jq -r .data.secret_id)

export ROLE_ID=$(cat /app/role_id)
echo "Unwrapped Secret ID $SECRET_ID"

cat <<EOF > payload.json
{
  "role_id": "$ROLE_ID",
  "secret_id": "$SECRET_ID"
}
EOF

# Login into Vault
export VAULT_TOKEN=$(curl -s --request POST \
            -d @payload.json \
            $VAULT_ADDR/v1/auth/approle/login | jq -r .auth.client_token)

echo "Login returned $VAULT_TOKEN"

curl -H "X-Vault-Request: true" \
     -H "X-Vault-Token: $VAULT_TOKEN" \
     $VAULT_ADDR/v1/secret/data/mysql/webapp | jq . > /app/secret

echo "Loaded secret $(cat /app/secret)"

python app.py
