# Service Account for CloudGuard Controller on CP Management for AKS

### Goals:
* build test AKS cluster
* define Service Account for CHKP CG Controller Datacenter Server (K8S) using TF
* test provided SA

### AKS: TF module deploying test cluster to new VNET



### SA: TF module creating CG Controller SA using TF

### Call AKS (K8S) API to list objects using SA token

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