# AWS lab with App spokes, TGW and CHKP VPC

Inspired by work at https://github.com/aws-samples/aws-network-firewall-terraform/
Diagram https://github.com/aws-samples/aws-network-firewall-terraform/blob/main/images/anfw-terraform-sample.jpg

```shell
# working folder
cd /workspaces/tf-playground/50-aws-tgw-chkp-vpc

tf init

tf plan
tf apply -auto-approve
```