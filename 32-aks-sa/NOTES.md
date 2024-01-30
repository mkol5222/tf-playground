# Service Account for CloudGuard Controller on CP Management for AKS

### Goals:
* build test AKS cluster
* define Service Account for CHKP CG Controller Datacenter Server (K8S) using TF
* test provided SA

### Usage
Open this as Github Codespace in VS Code Desktop and continue with commands:
```shell
# work in right context
cd /workspaces/tf-playground/32-aks-sa

# login to your Azure account
az login
# review
az account list -o table

# deploy test AKS cluster and CG Controller SA using TF
terraform init
# review and deploy
terraform apply

# no we have AKS cluster and SA for CG Controller usage

# our cluster
az aks list -o table
az aks get-credentials --admin --resource-group aks-sa-rg  --name aks-sa-cluster
kubectl get no
kubectl get ns

# Service account for CG Controller
# now terraform has both SA token and API URL in outputs
terraform output -raw sa_token
terraform output -raw api_server

# lets use it
T=$(terraform output -raw sa_token)
APISERVER=$(terraform output -raw api_server)
terraform output -raw api_server_cacert > /tmp/cacert.pem

curl -s $APISERVER/api/v1/namespaces/kube-system/pods/  --header "Authorization: Bearer $T" --cacert /tmp/cacert.pem | head

# cleanup
# because TF state is local, we would love to destroy env before destroying Codespace filesystem
terraform destroy
```

### AKS: TF module deploying test cluster to new VNET
* implemented in ./32-aks-sa/aks

### SA: TF module creating CG Controller SA using TF
* implemented in ./32-aks-sa/sa-k8s - look in cgcsa.tf

### Call AKS (K8S) API to list objects using SA token
* below

### After deployment

Once AKS is deployed, this is how to get kubectl access:
```shell
az aks list -o table
az aks get-credentials --resource-group aks-sa-rg  --name aks-sa-cluster
kubectl get no
kubectl get ns
# should show my-first-namespace created with TF

# attempt to retrieve SA token
echo; kubectl get secret/cloudguard-controller -o json | jq -r .data.token | base64 -d ; echo; echo

# store in var T
T=$(kubectl get secret/cloudguard-controller -o json | jq -r .data.token | base64 -d); echo $T

# API server URL
APISERVER=https://$(kubectl -n default get endpoints kubernetes --no-headers | awk '{ print $2 }'); echo $APISERVER

# test it
curl -s $APISERVER/openapi/v2  --header "Authorization: Bearer $T" -k
# list PODs
curl -s $APISERVER/api/v1/namespaces/kube-system/pods/  --header "Authorization: Bearer $T" -k
```