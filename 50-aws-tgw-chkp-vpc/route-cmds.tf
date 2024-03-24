
locals {
    tgw_rt_a = ""
    tgw_rt_b = ""
    tgw_rt_c = ""

    nat_rt_a = ""
    nat_rt_b = ""
    nat_rt_c = ""

    gwlbe_a = ""
    gwlbe_b = ""
    gwlbe_c = ""

    natgw_a = ""
    natgw_b = ""
    natgw_c = ""

    spokes_cidr = "10.0.0.0/8"
}

output "cmd_fw_on" {
    value = <<AAA
aws ec2 replace-route --route-table-id ${local.tgw_rt_a} --destination-cidr-block 0.0.0.0/0 --vpc-endpoint-id ${local.gwlbe_a};
aws ec2 replace-route --route-table-id ${local.tgw_rt_b} --destination-cidr-block 0.0.0.0/0 --vpc-endpoint-id ${local.gwlbe_b};
aws ec2 replace-route --route-table-id ${local.tgw_rt_c} --destination-cidr-block 0.0.0.0/0 --vpc-endpoint-id ${local.gwlbe_c};
aws ec2 create-route --route-table-id ${local.nat_rt_a} --destination-cidr-block ${local.spokes_cidr}--vpc-endpoint-id ${local.gwlbe_a};
aws ec2 create-route --route-table-id ${local.nat_rt_b} --destination-cidr-block ${local.spokes_cidr} --vpc-endpoint-id ${local.gwlbe_b};
aws ec2 create-route --route-table-id ${local.nat_rt_c} --destination-cidr-block ${local.spokes_cidr} --vpc-endpoint-id ${local.gwlbe_c};
AAA
}
output "cmd_fw_off" {
    value = <<BBB
aws ec2 replace-route --route-table-id ${local.tgw_rt_a} --destination-cidr-block 0.0.0.0/0 --nat-gateway-id ${local.natgw_a};
aws ec2 replace-route --route-table-id ${local.tgw_rt_b} --destination-cidr-block 0.0.0.0/0 --nat-gateway-id ${local.natgw_b};
aws ec2 replace-route --route-table-id ${local.tgw_rt_c} --destination-cidr-block 0.0.0.0/0 --nat-gateway-id ${local.natgw_c};
aws ec2 delete-route --route-table-id ${local.nat_rt_a} --destination-cidr-block ${local.spokes_cidr} -tgw; 
aws ec2 delete-route --route-table-id ${local.nat_rt_b} --destination-cidr-block ${local.spokes_cidr};
aws ec2 delete-route --route-table-id ${local.nat_rt_c} --destination-cidr-block ${local.spokes_cidr};

BBB
}