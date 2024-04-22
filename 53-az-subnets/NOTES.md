# subnet level policy in Azure

```shell
# auth
az login
az account list -o table

# workdir
cd /workspaces/tf-playground/53-az-subnets

tf init

tf plan

tf apply -auto-approve
az vm list-ip-addresses  -o table

terraform output -raw ssh_key > ~/.ssh/vm.key
chmod og= ~/.ssh/vm.key

VMIP=20.73.155.99
ssh -i ~/.ssh/vm.key azureuser@$VMIP

```