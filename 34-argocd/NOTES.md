# ArgoCD simple scenario

Inspiration by: 

```shell
# install KIND - https://kind.sigs.k8s.io/docs/user/quick-start/
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
# For ARM64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# get temporary cluster
kind create cluster --name argo
# see nodes
kubectl get no


# install ARGOCD - https://argo-cd.readthedocs.io/en/stable/getting_started/
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# see it running
kubectl get po -n argocd --watch

# server password
ARGOPWD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r .data.password | base64 -d)
echo $ARGOPWD
# server access
kubectl get svc -n argocd argocd-server
# https://localhost:8080 in background
kubectl port-forward -n argocd svc/argocd-server 8080:443 &

sudo netstat -nap | grep 8080
# kill -9 9287 # pid of kubectl port-forward

# login as admin with $ARGOPWD on  https://localhost:8080
echo $ARGOPWD

# ArgoCD web UI:
# + new app
# Application Name: app1
# Project: default
# Sync policy: manual
# Repository: https://github.com/mkol5222/argocd-learn-simple-app
# Cluster URL: https://kubernetes.default.svc
# Namespace: app1 (will be created later)
# CREATE

# hit sync

# error happens - open app1 and investigate failure
# spoiler: missing NS app1
# so SYNC again and look for auto-create namespace
# SYNCHRONIZE

# looks better? congratulations and welcome to world of GitOps

# delete cluster
kind delete cluster --name argocd
```