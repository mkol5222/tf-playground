
- [CP terraform code repo](https://github.com/CheckPointSW/CloudGuardIaaS/tree/master/terraform)

```shell

cd /workspaces/tf-playground/12-cp-tf-repo
git clone --depth 1 --filter=blob:none --no-checkout https://github.com/CheckPointSW/CloudGuardIaaS
cd CloudGuardIaaS
find .
git checkout master -- terraform/azure
find ./terraform

cd /workspaces/tf-playground/12-cp-tf-repo/CloudGuardIaaS/terraform/azure/single-gateway-new-vnet/
code README.md
```

Consider Smart-1 Cloud and get new gateway S1C token: https://portal.checkpoint.com/dashboard/smart-1cloud#/gateways-connection 

Copy Example from README.md to terraform.tfvars

[AZ SP for TF](https://gist.github.com/mkol5222/2e48e283c96fd6958583b4c828e09624)
```shell
az login
az account list -o table
# create and cut&paste to terraform.tfvars
# create and note deployment credentials, where relevant
SUBSCRIPTION_ID=$(az account list -o json | jq -r '.[]|select(.isDefault)|.id')
echo $SUBSCRIPTION_ID
# note credentials for config
AZCRED=$(az ad sp create-for-rbac --role="Owner" --scopes="/subscriptions/$SUBSCRIPTION_ID")
# echo "$AZCRED" | jq .
CLIENT_ID=$(echo "$AZCRED" | jq -r .appId)
CLIENT_SECRET=$(echo "$AZCRED" | jq -r .password)
TENANT_ID=$(echo "$AZCRED" | jq -r .tenant)
cat << EOF
client_secret = "$CLIENT_SECRET"
client_id = "$CLIENT_ID"
tenant_id = "$TENANT_ID"
subscription_id = "$SUBSCRIPTION_ID"
EOF
```

Focus on admin_password, sic_key and smart_1_cloud_token in terraform.tfvars

```bash
cd /workspaces/tf-playground/12-cp-tf-repo/CloudGuardIaaS/terraform/azure/single-gateway-new-vnet/
terraform init
terraform apply

terraform destroy
```