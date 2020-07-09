export HOST_IP=$(ipconfig getifaddr en0)
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

vault server -dev -dev-root-token-id=root -dev-listen-address=0.0.0.0:8200 &

sleep 2
# vault secrets enable -path=secret -version=2 kv
vault kv put secret/mysql/webapp secret=password
