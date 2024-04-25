# Azure VM with AppSec on MicroK8S

```shell
# login to Az
az login
az account list -o table

# workdir
cd /workspaces/tf-playground/54-appsec-az-vm
tf init

tf apply -auto-approve
```