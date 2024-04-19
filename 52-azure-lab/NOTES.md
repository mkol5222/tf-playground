
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

# access linux VM
mkdir -p ~/.ssh
tf output -raw linux_key > ~/.ssh/linux1.key
chmod o= ~/.ssh/linux1.key
chmod g= ~/.ssh/linux1.key
tf output -raw linux_ssh_config
tf output -raw linux_ssh_config | tee  ~/.ssh/config
# should get Ubuntu machine prompt
ssh linux1

# cleanup - remove SP
az ad sp delete --id $(az ad sp list --display-name 52-azure-lab --query "[].{id:appId}" -o tsv)
```