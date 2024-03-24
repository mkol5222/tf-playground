# AWS lab with App spokes, TGW and CHKP VPC

Inspired by work at https://github.com/aws-samples/aws-network-firewall-terraform/
Diagram https://github.com/aws-samples/aws-network-firewall-terraform/blob/main/images/anfw-terraform-sample.jpg

```shell
# working folder
cd /workspaces/tf-playground/50-aws-tgw-chkp-vpc

tf init

tf plan
tf apply -auto-approve

# CP management console
ssh admin@34.247.143.157 -i C:\Users\mkoldov\.ssh\azureshell.key

# x-chkp-tags	management=CP-Management-gwlb-tf:template=gwlb-configuration:ip-address=private
autoprov_cfg init AWS -mn CP-Management-gwlb-tf -tn gwlb-configuration -otp WelcomeHome1984 -po Standard -cn cpman -r eu-west-1 -iam -ver R81.20

autoprov_cfg set template -tn gwlb-configuration -ia -ips


```