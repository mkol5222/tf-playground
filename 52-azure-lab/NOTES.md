
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

# cleanup - remove SP
az ad sp delete --id $(az ad sp list --display-name 52-azure-lab --query "[].{id:appId}" -o tsv)
```