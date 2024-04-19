
# Azure lab

```shell
# project folder
cd /workspaces/tf-playground/52-azure-lab

# create SP for TF
./scripts/create-az-sp.sh

# copy output to terraform.tfvars Azure SP section

# deploy
terraform init
tf apply -target azurerm_subnet.cpman_subnet
tf apply -target azurerm_subnet.frontend
tf apply -target azurerm_subnet.backend -auto-approve
terraform apply

# ssh access cpman
# https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.Compute%2FVirtualMachines
# 
ssh admin@23.97.210.27
# cpman cloud init
tail -f /var/log/cloud_config.log
# cpman
api status
# cpman API readiness SUCESSFUL ???
api status | grep 'API readiness test'

# login with SMartDashboard too
# 

# API reference
# https://sc1.checkpoint.com/documents/latest/APIs/#~v1.9.1%20

# cpman
mgmt_cli -r true show hosts limit 5 offset 0 details-level "standard"  --format json
# cpman
mgmt_cli -r true add host name "tik.cesnet.cz" ip-address "195.113.144.201" --format json
mgmt_cli -r true add host name "tak.cesnet.cz" ip-address "195.113.144.238" --format json
# publish
mgmt_cli -r true publish

# api playground - folder 
cd /workspaces/tf-playground/52-azure-lab/api-playground
# use VScode REST client

# access linux VM
mkdir -p ~/.ssh
tf output -raw linux_ssh_key > ~/.ssh/linux1.key
chmod og= ~/.ssh/linux1.key
tf output -raw linux_ssh_config
tf output -raw linux_ssh_config | tee  ~/.ssh/config
# should get Ubuntu machine prompt
ssh linux1

# linux1


# CloudGuard Controller
 ./scripts/create-reader-sp.sh 
 # configure Azure DC in SmartConsole

 # configure CME for VMSS - use real credentials!!! (example below is revoked RO Az SP)
autoprov_cfg init Azure -mn mgmt -tn vmss_template -otp WelcomeHome1984 -ver R81.20 -po Standard -cn ctrl -sb f4ad5e85-ec75-4321-8854-ed7eb611f61d -at 01605c2e-84df-4dfc-af6c-4f706350e670 -aci 6d64ad49-fd32-437d-9215-5f79caa9cf10 -acs "xR_8Q~IViRJS5k6D3nu8KDa6gWWQd5BIeP5RNbhG"

autoprov_cfg set template -tn vmss_template -ia -ips

autoprov_cfg show all

tail -f /var/log/CPcme/cme.log


# install netbox
cd /workspaces/tf-playground/52-azure-lab
git clone -b release https://github.com/netbox-community/netbox-docker.git
cd netbox-docker
tee docker-compose.override.yml <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - 8000:8080
EOF
docker compose pull
docker compose up

# create user
cd /workspaces/tf-playground/52-azure-lab/netbox-docker
docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser

# login and create new API KEY
# note it: 0d5b4d5f9dacc2937a94627cb26b71e750739ed8

# create tags: net, host
# create IPAM IP addresses - /32 host and some /n network

# consume IP addresses
TOKEN=0d5b4d5f9dacc2937a94627cb26b71e750739ed8
curl -s http://127.0.0.1:8000/api/ipam/ip-addresses/ -vvv -H "Authorization: Token $TOKEN"
curl -s http://127.0.0.1:8000/api/ipam/ip-addresses/?tag=net -vvv -H "Authorization: Token $TOKEN"
curl -s http://127.0.0.1:8000/api/ipam/ip-addresses/?tag=host -vvv -H "Authorization: Token $TOKEN"


# backup netbox
cd /workspaces/tf-playground/52-azure-lab/netbox-docker
cat env/postgres.env
# https://docs.netbox.dev/en/stable/administration/replicating-netbox/
export PGPASSWORD=J5brHrAXFLQSif0K
docker-compose exec -it postgres pg_dump --username netbox --host localhost netbox  > ../netbox_backup.sql
head ./netbox_backup.sql

# restore netbox
cd /workspaces/tf-playground/52-azure-lab/netbox-docker
cat env/postgres.env
# https://docs.netbox.dev/en/stable/administration/replicating-netbox/
export PGPASSWORD=J5brHrAXFLQSif0K
docker-compose down -v
docker-compose up -d
docker-compose exec -it postgres psql --username netbox -c 'create database netbox'
docker-compose exec -T postgres psql --username netbox netbox < ../netbox_backup.sql

# cleanup - remove SP
az ad sp delete --id $(az ad sp list --display-name 52-azure-lab --query "[].{id:appId}" -o tsv)
az ad sp delete --id $(az ad sp list --display-name 52-azure-lab-ro --query "[].{id:appId}" -o tsv)
```