output "spoke_vpc_a_id" {
  value = aws_vpc.spoke_vpc_a.id
}
output "spoke_vpc_b_id" {
  value = aws_vpc.spoke_vpc_b.id
}

output "spoke_vpc_a_protected_subnet_a_id" {
  value = aws_subnet.spoke_vpc_a_protected_subnet[0].id
}
output "spoke_vpc_b_protected_subnet_a_id" {
  value = aws_subnet.spoke_vpc_b_protected_subnet[0].id
}

output "spoke_vpc_a_endpoint_subnet_ids" {
  value = [
    aws_subnet.spoke_vpc_a_endpoint_subnet[0].id,
    aws_subnet.spoke_vpc_a_endpoint_subnet[1].id,
    aws_subnet.spoke_vpc_a_endpoint_subnet[2].id
  ]
}

output "spoke_vpc_b_endpoint_subnet_ids" {
  value = [
    aws_subnet.spoke_vpc_b_endpoint_subnet[0].id,
    aws_subnet.spoke_vpc_b_endpoint_subnet[1].id,
    aws_subnet.spoke_vpc_b_endpoint_subnet[2].id
  ]
}

output "inspection_vpc_id" {
    value = aws_vpc.inspection_vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.inspection_vpc_igw.id
}

output "inspection_vpc_cidr" {
    value = aws_vpc.inspection_vpc.cidr_block
}

output "inspection_vpc_nat_gw_ids" {
    value =    aws_nat_gateway.inspection_vpc_nat_gw[*].id
}

output "firewall_subnet_ids" {
  value =     aws_subnet.inspection_vpc_firewall_subnet[*].id
}

output "tgw_subnet_ids" {
  value =     aws_subnet.inspection_vpc_tgw_subnet[*].id
}

output "public_subnet_ids" {
  value =     aws_subnet.inspection_vpc_public_subnet[*].id
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

