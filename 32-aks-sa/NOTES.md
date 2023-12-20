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
```