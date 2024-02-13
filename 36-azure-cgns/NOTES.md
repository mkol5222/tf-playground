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

alias tf=terraform
tf init
tf apply -target module.management
tf apply -target azurerm_subnet.cp-front
tf apply -target azurerm_subnet.cp-back
tf apply -target module.vmss
tf apply -target module.linux

mkdir -p ~/.ssh
tf output -raw linux_key > ~/.ssh/linux1.key
chmod o= ~/.ssh/linux1.key
chmod g= ~/.ssh/linux1.key
tf output -raw linux_ssh_config
tf output -raw linux_ssh_config | tee -a  ~/.ssh/config
# or OVERWRITE!!!
tf output -raw linux_ssh_config | tee  ~/.ssh/config
# should get Ubuntu machine prompt
ssh linux1

# on cp man CME
# fill vars from Keepass
client_secret="i1F8Q~Tlxxx"
client_id="323xxx"
tenant_id="01605xxx"
subscription_id="f4axxx"

autoprov-cfg -f init Azure -mn cp-man-tf -tn vmss_template -otp WelcomeHome1984 -ver R81.20 -po Standard -cn CN1 -sb $subscription_id -at $tenant_id -acs $client_secret -aci $client_id

autoprov-cfg set template -tn vmss_template -ia -ips 

autoprov-cfg show all
tail -f /var/log/CPcme/cme.log

###
# SG
# set static-route 10.0.0.0/24 nexthop gateway address 10.0.11.1 on
# set static-route 10.0.101.0/24 nexthop gateway address 10.0.11.1 on 
# as CME gw script
###

az vmss list -o table
az vmss list-instances -o table --name cp-vmss-tf  -g CP-VMSS-TF 

az vmss nic list -g CP-VMSS-TF  --vmss-name cp-vmss-tf -o table
az vmss nic list -g CP-VMSS-TF  --vmss-name cp-vmss-tf | grep -i ips
az vmss list-instance-public-ips -g CP-VMSS-TF --name cp-vmss-tf -o table



```