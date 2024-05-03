# Azure VM with AppSec on MicroK8S

```shell
# login to Az
az login
az account list -o table

# workdir
cd /workspaces/tf-playground/54-appsec-az-vm

# make SA for tfstate
cd tfstate
tf init
tf apply -auto-approve
# see sa params for tfstate:
tf output -raw tfstate_vars
cd ..
# copy tfstate parameters to provider.tf

# workdir
cd /workspaces/tf-playground/54-appsec-az-vm
tf init

tf apply -auto-approve

# ssh

mkdir -p ~/.ssh
tf output -raw ssh_key > ~/.ssh/appsecvm.key
chmod og= ~/.ssh/appsecvm.key
tf output -raw ssh_config | tee -a ~/.ssh/config
cat ~/.ssh/config
ssh appsecvm -v

# cleanup
cd /workspaces/tf-playground/54-appsec-az-vm
tf destroy -auto-approve
cd /workspaces/tf-playground/54-appsec-az-vm/tfstate
tf destroy -auto-approve
```