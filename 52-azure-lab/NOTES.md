
# Azure lab

```shell
# project folder
cd /workspaces/tf-playground/52-azure-lab

# create SP for TF
./scripts/create-az-sp.sh

# copy output to terraform.tfvars Azure SP section

# deploy
terraform init
tf apply -target module.vnet -auto-approve
# sp for CME and CG Controller
tf apply -target module.reader -auto-approve
cat tf-policy/reader.json
# tf apply -target module.reader -auto-approve -replace module.reader.local_file.reader_creds
# one network exists, modules depending on "existing vnet" will work
tf apply -target module.cpman -auto-approve

tf apply -target module.linux -auto-approve

# ssh access cpman
# https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.Compute%2FVirtualMachines
#  use real IP address!

az vm list-ip-addresses  -o table

CPMAN=13.69.30.89
ssh admin@$CPMAN
# cpman cloud init - look for "cloud_config finished successfully"
tail -f /var/log/cloud_config.log
# cpman
api status
# cpman API readiness SUCESSFUL ???
api status | grep 'API readiness test'

# api user

# create api user
mgmt_cli -r true add administrator name "cpapi" permissions-profile "read write all" authentication-method "api key" --domain 'System Data' --format json

# add api-key
# https://sc1.checkpoint.com/documents/latest/APIs/index.html#cli/add-api-key~v1.9.1%20
APIKEYRES=$(mgmt_cli -r true add api-key admin-name "cpapi"  --domain 'System Data' --format json)
echo "$APIKEYRES" | jq -r '.["api-key"]'

# take note of API key and IP address

# public IP of management
ifconfig eth0:1

mgmt_cli -r true publish

# for local tf-policy/terraform.tfvars
cat << EOF 
cpserver="52.233.177.94"
cpapikey="43x5Adw//rRLAidUZVPMzQ=="
EOF

# logout and continue with policy
exit
cd /workspaces/tf-playground/52-azure-lab/tf-policy

tf init
tf plan
tf apply -auto-approve
tf apply -auto-approve -var publish=true
tf apply -auto-approve -var install=true

curl -OL https://github.com/mkol5222/my-cp-mgmt-commands/raw/main/releases/linux-amd64/publish
chmod +x publish
export CHECKPOINT_SERVER=$CPMAN
export CHECKPOINT_API_KEY="r0GFcdIDKPIoBhaxqjvJ/A=="
./publish

# login with SMartDashboard too
# 

# API reference
# https://sc1.checkpoint.com/documents/latest/APIs/#~v1.9.1%20

#  cpman use real IP address!
ssh admin@$CPMAN

# cpman
mgmt_cli -r true show hosts limit 5 offset 0 details-level "standard"  --format json
# cpman
mgmt_cli -r true add host name "tik.cesnet.cz" ip-address "195.113.144.201" --format json
mgmt_cli -r true add host name "tak.cesnet.cz" ip-address "195.113.144.238" --format json
# publish
mgmt_cli -r true publish

# api playground - folder 
cd /workspaces/tf-playground/52-azure-lab/api-playground
# use VScode REST client






# CloudGuard Controller
 # ./scripts/create-reader-sp.sh 
 # configure Azure DC in SmartConsole

cd /workspaces/tf-playground/52-azure-lab
CLIENT_ID=$(cat ./tf-policy/reader.json | jq -r .client_id)
CLIENT_SECRET=$(cat ./tf-policy/reader.json | jq -r .client_secret)
TENANT_ID=$(cat ./tf-policy/reader.json | jq -r .tenant_id)
SUBSCRIPTION_ID=$(cat ./tf-policy/reader.json | jq -r .subscription_id)

# configure CME for VMSS - use real credentials!!! (example below is revoked RO Az SP)
# command to run @cpman
echo autoprov_cfg init Azure -mn mgmt -tn vmss_template -otp WelcomeHome1984 -ver R81.20 -po Azure -cn ctrl -sb $SUBSCRIPTION_ID -at $TENANT_ID -aci $CLIENT_ID -acs "$CLIENT_SECRET"

#  cpman use real IP address!
CPMAN='52.233.177.94'
ssh admin@$CPMAN
# run autoprov_cfg init Azure  ...

autoprov_cfg set template -tn vmss_template -ia -ips

autoprov_cfg show all

tail -f /var/log/CPcme/cme.log

exit # cpman

# deploy VMSS
cd /workspaces/tf-playground/52-azure-lab
# deploy VMSS
terraform apply -target module.vmss -auto-approve



# install netbox
cd /workspaces/tf-playground/52-azure-lab
rm -rf netbox-docker
git clone -b release https://github.com/netbox-community/netbox-docker.git
cd netbox-docker

tee docker-compose.override.yml <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - 8000:8080
EOF
docker compose pull
docker compose up

# wait for netbox init done
# restore netbox - one more term
cd /workspaces/tf-playground/52-azure-lab/netbox-docker
cat env/postgres.env
# https://docs.netbox.dev/en/stable/administration/replicating-netbox/
export PGPASSWORD=J5brHrAXFLQSif0K
#docker-compose down -v
#docker-compose up # wait for initialization to finish!
docker-compose stop netbox netbox-housekeeping netbox-worker
docker-compose ps

#docker-compose exec -it postgres psql --username netbox -c 'drop database netbox'
#docker-compose exec -it postgres psql --username netbox -c 'create database netbox'
docker-compose exec -T postgres psql --username netbox netbox < ../netbox_backup.sql
docker compose up
# admin / vpn123 in web UI
# generate new token

# feefb124793eda04a1f88ed818323462bbd92ce4

# create user
#cd /workspaces/tf-playground/52-azure-lab/netbox-docker
#docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser

# login and create new API KEY
# note it: 0d5b4d5f9dacc2937a94627cb26b71e750739ed8

# create tags: net, host
# create IPAM IP addresses - /32 host and some /n network

# consume IP addresses
TOKEN=feefb124793eda04a1f88ed818323462bbd92ce4
curl -s http://127.0.0.1:8000/api/ipam/ip-addresses/ -vvv -H "Authorization: Token $TOKEN"
curl -s http://127.0.0.1:8000/api/ipam/ip-addresses/?tag=net -vvv -H "Authorization: Token $TOKEN"
curl -s http://127.0.0.1:8000/api/ipam/ip-addresses/?tag=host -vvv -H "Authorization: Token $TOKEN"

cd /workspaces/tf-playground/52-azure-lab/tf-netbox
# token
# netbox_apitoken="3ba6988084555869c69a9ee374190f4da9bb221e"
code terraform.tfvars

# and management creds.
cat ../tf-policy/terraform.tfvars

tf init
tf plan
tf apply -auto-approve

# backup netbox
cd /workspaces/tf-playground/52-azure-lab/netbox-docker
cat env/postgres.env
# https://docs.netbox.dev/en/stable/administration/replicating-netbox/
export PGPASSWORD=J5brHrAXFLQSif0K
docker-compose exec -it postgres pg_dump --username netbox --host localhost netbox  > ../netbox_backup.sql
head ./netbox_backup.sql


# route via VMSS
cd /workspaces/tf-playground/52-azure-lab
terraform apply -target=module.linux -var route_through_firewall=true -auto-approve

# access linux VM
cd /workspaces/tf-playground/52-azure-lab
mkdir -p ~/.ssh
tf output -raw linux_ssh_key > ~/.ssh/linux1.key
chmod og= ~/.ssh/linux1.key
tf output -raw linux_ssh_config
tf output -raw linux_ssh_config | tee  ~/.ssh/config
# should get Ubuntu machine prompt
ssh linux1

# linux1
while true; do curl -s -m1 ip.iol.cz/ip/; echo; ping -c1 1.1.1.1; sleep 3; done

# aks
terraform apply -target module.aks -var route_through_firewall=false -auto-approve
terraform apply -target module.vnet -var route_through_firewall=false -auto-approve
terraform apply -target module.sa -auto-approve
terraform output -raw aks_creds | jq . > ./tf-policy/sa.json

# creds for AKS

# our cluster
az aks list -o table
az aks get-credentials --admin --resource-group lab-52-aks  --name aksdemo
kubectl get no
kubectl get ns

### Disable NAT for traffice from Pods

kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: azure-ip-masq-agent-config
  namespace: kube-system
  labels:
    component: ip-masq-agent
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: EnsureExists
data:
  ip-masq-agent: |-
    nonMasqueradeCIDRs:
      - 0.0.0.0/0
    masqLinkLocal: true
EOF


# some traffic
kubectl create deploy web --image nginx --replicas 6
kubectl get po -l app=web -o wide
PODS=$(kubectl get po -o name -l app=web)
while true; do for P in $PODS; do echo $P; kubectl exec -it $P -- curl ip.iol.cz/ip/ -m5 -s; echo; done; done

# via FW
cd /workspaces/tf-playground/52-azure-lab
terraform apply -var route_through_firewall=true -auto-approve

# cleanup - remove infra and SP
cd /workspaces/tf-playground/52-azure-lab
terraform destroy -target=module.sa -auto-approve
terraform destroy -target=module.aks -auto-approve
terraform destroy -target=module.vmss -auto-approve
terraform destroy -target=module.cpman -auto-approve
terraform destroy -target=module.linux -auto-approve
terraform destroy -target=module.vnet -auto-approve
terraform destroy -target=module.reader -auto-approve
terraform destroy -auto-approve
terraform state list # something left?
# then
terraform destroy -auto-approve -target module.cpman.module.network-security-group.azurerm_network_security_group.nsg

az ad sp list --all --show-mine -o table
az ad sp delete --id $(az ad sp list --display-name 52-azure-lab --query "[].{id:appId}" -o tsv)
az ad sp delete --id $(az ad sp list --display-name 52-azure-lab-ro --query "[].{id:appId}" -o tsv)
# none left?
az ad sp list --all --show-mine -o table
```