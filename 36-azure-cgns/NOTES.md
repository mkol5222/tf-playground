# Azure CGNS deployments

```shell
# login to Azure
az login
az accout list -o table

# working folder
cd /workspaces/tf-playground/36-azure-cgns/

# create Owner SP for your subcription to use with TF
./create-az-sp-for-cp-tf.sh
# save credentials in "Keepass"

# save to (not versioned in GIT) ./terraform.tfvars (it is in .gitignore to prevent secrets leaking)
cat <<EOF | tee ./terraform.tfvars
client_secret = "i1F8Qxxx"
client_id = "3230xx"
tenant_id = "01605c2xx"
subscription_id = "f4ad5xxx"
EOF

# will use https://github.com/CheckPointSW/CloudGuardIaaS/tree/master/terraform/azure/management-new-vnet

```