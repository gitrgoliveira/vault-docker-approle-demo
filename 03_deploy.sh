export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

# These are the tasks to be done by your deployment / orchestration system
vault write -wrap-ttl=10m \
    -field=wrapping_token \
    -f auth/approle/role/webapp/secret-id > demo_app_secret_id

export HOST_IP=$(ipconfig getifaddr en0)
docker-compose up -d

echo "Application available in http://localhost:5000"
