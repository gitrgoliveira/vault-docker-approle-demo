# Vault AppRole demo with Docker

This example shows what is expected from a secure AppRole workflow.

Inspired by the Learn guide: https://learn.hashicorp.com/vault/developer/approle

## Requirements

This demo was developed to work in MacOS.

Dependencies:
 - Vault binary
 - Docker Compose

## Demo Steps

### Start up

`00_start.sh` will just start a local dev vault client and create a dummy value in `secret/mysql/webapp`

### Set up

`01_setup.sh` are the tasks expected to be executed by a Vault Namespace admin.

In a production scenario you are expected to have 3 roles:
 - Application - The secret consumer
 - Build system - The one that only has access to read the necessary role id's
 - Deployment system - This user should only be able to generate wrapped secret id's

### Build

`02_build.sh` reads the static role ID from Vault and introduces that into the docker container.
This value can also be wrapped, but beware because a wrapped secret can only be read once, which may not work well when you have replicas.

## Deploy

`03_deploy.sh` is the deployment stage where the secret ID is read and injected into the application using docker secrets. This can be done using the Terraform Docker provider https://www.terraform.io/docs/providers/docker/r/secret.html

There should be 2 different personas that are able to retrieve a part of the approle.

If a single identity is able to retrieve both, then they are also able to login to Vault and impersonate the application.

**This value is wrapped** in this use case, but beware because a wrapped secret can only be read once, which may not work well when you have replicas.

## Run
When the application starts, it has access to both `role_id` and `secret_id`.

With these 2 pieces of information, the application can use simple HTTP calls to retrieve the `VAULT_TOKEN` and the secret it wants.

For convenience I added those curl requests in a shell script in `./demo_app/app.sh`, which outputs the secrets to stdout, so *do not use in production as is!!*

You can see this by running `docker-compose logs`