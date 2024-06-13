# Azure VM with AppSec on MicroK8S

```shell
# login to Az
az login
az account list -o table

# workdir
cd /workspaces/tf-playground/57-logexporter

# BUT FIRST make Storage Account for tfstate
cd /workspaces/tf-playground/57-logexporter/tfstate
tf init
tf apply -auto-approve
# see sa params for tfstate:
tf output -raw tfstate_vars
cd ..
code provider.tf

# IMPORTANT 
# cut&paste tfstate parameters from tfstate_vars output to provider.tf
#   under backend "azurerm"  section

# workdir
cd /workspaces/tf-playground/57-logexporter

# once provider.tf backend section was updated!!!
tf init
terraform init -reconfigure

tf apply -auto-approve

# ssh
mkdir -p ~/.ssh
tf output -raw ssh_key > ~/.ssh/logexporter.key
chmod og= ~/.ssh/logexporter.key
tf output -raw ssh_config | tee -a ~/.ssh/config
cat ~/.ssh/config
ssh logexporter -v

# cleanup
cd /workspaces/tf-playground/57-logexporter
tf destroy -auto-approve
cd  /workspaces/tf-playground/57-logexporter/tfstate
tf destroy -auto-approve
```