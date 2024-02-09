# Service Account for CloudGuard Controller on CP Management for AKS

### Goals:
* build test AKS cluster
* define Service Account for CHKP CG Controller Datacenter Server (K8S) using TF
* test provided SA

### Usage
Open this as Github Codespace in VS Code Desktop and continue with commands:
```shell
# work in right context
cd /workspaces/tf-playground/33-aks-policy

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
az aks get-credentials --admin --resource-group aks-sa-rg  --name aks-sa-cluster
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

### Network Policy

https://learn.microsoft.com/en-us/azure/aks/use-network-policies#overview-of-network-policy

```shell
# deploy service
kubectl create deploy web --image nginx --port 80

# connect from service to Internet - get public IP

# wait a bit ;-)
WEBPOD=$(kubectl get po -l app=web -o name | head -1)
kubectl exec -it $WEBPOD -- curl ip.iol.cz/ip/

# we can keep it probing and SPLIT THE TERMINAL
while true; do kubectl exec -it $WEBPOD -- curl -s -m1 ip.iol.cz/ip/; echo ; sleep 3; done

# now we deny all agress from default NS:
cat <<'EOF' | kubectl apply -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: default-deny-all-egress
  namespace: default
spec:
  policyTypes:
  - Egress
  podSelector: {}
  egress: []
EOF

# did it impact the traffic from NGINX pod?

# lets allow it resolve DNS and do HTTP(S)
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: multi-port-egress
  namespace: default
spec:
  podSelector: {}
  policyTypes:
    - Egress
  egress:
    - ports:
        - protocol: TCP
          port: 53
        - protocol: UDP
          port: 53          
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443
EOF
```

### Linux VM

```shell
mkdir -p ~/.ssh
tf output -raw linux_key > ~/.ssh/linux1.key
chmod o= ~/.ssh/linux1.key
chmod g= ~/.ssh/linux1.key
tf output -raw linux_ssh_config
tf output -raw linux_ssh_config | tee  ~/.ssh/config
# should get Ubuntu machine prompt
ssh linux1
# try in VM
curl ip.iol.cz/ip/; echo; exit
# got public IP of Linux VM

# get IP of NGINX pod:
kubectl get pod -l app=web -o json | jq -r '.items[0].status.podIP'
# save
PODIP=$(kubectl get pod -l app=web -o json | jq -r '.items[0].status.podIP')
# linux should reach it (Azure CNI)
ssh linux1 curl $PODIP
# confirmed

ssh linux1 sudo apt update; ssh linux1 sudo apt install -y nginx
```


### Disable NAT for traffice from Pods

```bash
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

# remove config mod
kubectl delete cm/azure-ip-masq-agent-config -n kube-system

# scale web deploy
kubectl scale deploy web --replicas 6
PODS=$(kubectl get pod -l app=web -o name)
# go from every pod
while true; do
  for P in $PODS; do echo $P; kubectl exec -it $P -- curl -m1 ip.iol.cz/ip/; echo; done
  for P in $PODS; do echo $P; kubectl exec -it $P -- curl -m1 ifconfig.me; echo; done
  for P in $PODS; do echo $P; kubectl exec -it $P -- curl -m1 10.68.2.4; echo; done
  sleep 2;
done
```

Ingress https://learn.microsoft.com/en-us/azure/firewall/protect-azure-kubernetes-service
