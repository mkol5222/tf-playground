

Work in progress - XFF as IDA source

```shell


kubectl run -it --rm --restart=Never --image=nginx client2 -- sh -c 'curl -vvv -H "My-X-Forwarded-For: $(hostname -i)" -H "X-Forwarded-For: $(hostname -i)" http://httpbin.org/headers'

PODS=$(kubectl get pod -l app=web -o name)
for P in $PODS; do kubectl exec -it $P -- sh -c 'curl -vvv -H "My-X-Forwarded-For: $(hostname -i)" -H "X-Forwarded-For: $(hostname -i)" http://httpbin.org/headers'; done

PODS=$(kubectl get pod -l app=web -o name)
for P in $PODS; do kubectl exec -it $P -- sh -c 'curl -vvv -H "My-X-Forwarded-For: $(hostname -i)" -H "X-Forwarded-For: $(hostname -i)" http://ip.iol.cz/ip/'; done

PODS=$(kubectl get pod -l app=web -o name)
for P in $PODS; do kubectl exec -it $P -- sh -c 'curl -vvv -H "My-X-Forwarded-For: $(hostname -i)" -H "X-Forwarded-For: $(hostname -i)" https://checkpoint.com'; done

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
      - 10.0.0.0/8
    masqLinkLocal: true
EOF

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

10.68.1.58

for P in $PODS; do echo $P; kubectl exec -n test -it $P -- sh -c 'curl ip.iol.cz/ip/ -H "X-Forwarded-For: 10.68.1.13"'; done

while true; do
PODS=$(kubectl get pod -n test -o name)
for P in $PODS; do echo $P; kubectl exec -n test -it $P -- sh -c 'curl ip.iol.cz/ip/'; done
for P in $PODS; do echo $P; kubectl exec -n test -it $P -- sh -c 'echo curl ip.iol.cz/ip/ -H "X-Forwarded-For: $(hostname -i)"'; done

for P in $PODS; do echo $P; kubectl exec -n test -it $P -- sh -c 'echo curl ifconfig.me -H "X-Forwarded-For: $(hostname -i)"'; done

PODS=$(kubectl get pod -l app=web -o name)
for P in $PODS; do echo $P; kubectl exec -n default -it $P -- sh -c 'curl ip.iol.cz/ip/ -H "X-Forwarded-For: $(hostname -i)"'; done
done

while true; do
PODS=$(kubectl get pod -n test -o name)
for P in $PODS; do echo $P; kubectl exec -n test -it $P -- sh -c 'curl httpbin.org -H "NOX-Forwarded-For: $(hostname -i)"'; done

PODS=$(kubectl get pod -l app=web -o name)
for P in $PODS; do echo $P; kubectl exec -n default -it $P -- sh -c 'curl httpbin.org -H "NOX-Forwarded-For: $(hostname -i)"'; done
done


PODS=$(kubectl get pod -n t2 -o name)
for P in $PODS; do echo $P; kubectl exec -n t2 -it $P -- sh -c 'curl ip.iol.cz/ip/ -H "X-Forwarded-For: $(hostname -i)"'; done
for P in $PODS; do echo $P; kubectl exec -n t2 -it $P -- sh -c 'curl ip.iol.cz/ip/ '; done


PODS=$(kubectl get pod -n t3 -o name)
for P in $PODS; do echo $P; kubectl exec -n t3 -it $P -- sh -c 'curl -H "X-Forwarded-For: $(hostname -i)" ip.iol.cz/ip/ '; done
for P in $PODS; do echo $P; kubectl exec -n t3 -it $P -- sh -c 'curl ip.iol.cz/ip/ '; done

PODS=$(kubectl get pod -l app=web -o name)
for P in $PODS; do echo $P; kubectl exec -it $P -- sh -c 'curl ip.iol.cz/ip/ '; done

PODS=$(kubectl get pod -n test6 -o name); echo $PODS
for P in $PODS; do echo $P; kubectl exec -n test6 -it $P -- sh -c 'echo curl ip.iol.cz/ip/ -H "X-Forwarded-For: $(hostname -i)"'; done
for P in $PODS; do echo $P; kubectl exec -n test6 -it $P -- sh -c 'curl ip.iol.cz/ip/ -H "X-Forwarded-For: $(hostname -i)"'; done
for P in $PODS; do echo $P; kubectl exec -it $P -- sh -c 'curl ip.iol.cz/ip/ '; done


PODS=$(kubectl get pod -n test6 -o name -l app=web6); echo $PODS
for P in $PODS; do echo $P; kubectl exec -n test6 -it $P -- sh -c 'hostname -i'; done

while true; do
for P in $PODS; do echo $P; kubectl exec -n test6 -it $P -- sh -c 'curl -k https://ifconfig.me -H "X-Forwarded-For: $(hostname -i)"'; done
done


for P in $PODS; do echo $P; kubectl exec -n test6 -it $P -- sh -c 'curl ip.iol.cz/ip/ -H "X-Forwarded-For: $(hostname -i)"'; done