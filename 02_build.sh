export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

# These are the tasks to be done by your build system
vault read -field role_id auth/approle/role/webapp/role-id > ./demo_app/role_id
docker build demo_app/ -t demo_app:v1
