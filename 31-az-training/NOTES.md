# restricted Azure lab

Pay attention to existing resource group name:
e.g. ODL-ccvsa-1112866-03
under https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups 

```bash
az login
az account list -o table
```

```bash
# configure template
cat << EOF > terraform.tfvars
rg = "ODL-ccvsa-1112866-03"
admin_password = "Vpn123456#Ok"
route_through_firewall = false
EOF

# review
cat terraform.tfvars

# prepare
terraform init

# plan
terraform plan

# deploy
terraform apply

# Linux SSH access
mkdir -p ~/.ssh
terraform output -raw ssh_config > ~/.ssh/config
terraform output -raw ssh_config > ~/.ssh/config
terraform output -raw ssh_key > ~/.ssh/ubuntu1.key
chmod 400 ~/.ssh/ubuntu1.key
# enjoy access
ssh ubuntu1


# fix permissions for CP serial console


# remember to remove resources
terraform destroy
```
