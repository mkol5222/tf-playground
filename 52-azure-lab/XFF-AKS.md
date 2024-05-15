```shell
# once you have cpman, VMSS and AKS accouding to NOTES.md ...

kubectl create deploy proxy --image ghcr.io/mkol5222/squid-openssl-docker:2024-04-18
kubectl expose deploy/proxy --port 3128
kubectl get svc proxy

# existing pods
kubectl get po -l app=web -o wide
PODS=$(kubectl get po -o name -l app=web)
for P in $PODS; do echo $P; kubectl exec -it $P -- curl ip.iol.cz/ip/ -m5 -s; echo; done
# via proxy
for P in $PODS; do echo $P; kubectl exec -it $P -- curl --proxy http://proxy.default.svc.cluster.local:3128 -vvv "ip.iol.cz/ip/" -m5 -s; echo; done

for P in $PODS; do echo $P; kubectl exec -it $P -- curl --proxy http://proxy.default.svc.cluster.local:3128 -vvv "http://dev.to" -k -m5 -vvv; echo; done
```