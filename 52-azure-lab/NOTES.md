
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

# cleanup - remove SP
az ad sp delete --id $(az ad sp list --display-name 52-azure-lab --query "[].{id:appId}" -o tsv)
```