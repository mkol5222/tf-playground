
# managed routes

# - tgw_subnet - attaching TGW
# - public_subnet - NAT Gateways and IGW
# - firewall_subnet - Check Point GWs and GWLB
# - gwlb_subnet - GWLBe route table

# no CHKP situation
# tgw_subnet -> NAT gateway (public_subnet) -> IGW -> Internet
# IGW -> NAT gateway (public_subnet) -> TGW (tgw_subnet)

# with CGNS
# tgw_subnet -> GWLBe (gwlbe_subnet) -> NAT gateway (public_subnet) -> IGW -> Internet
# IGW -> NAT gateway (public_subnet) -> GWLBe (gwlbe_subnet) -> TGW (tgw_subnet)

resource "aws_route_table" "inspection_vpc_tgw_subnet_route_table" {
  count  = 3 //length(data.aws_availability_zones.available.names)
  vpc_id = var.inspection_vpc_id
  #   route {
  #   cidr_block     = "0.0.0.0/0"
  #   # to Internet via NAT gw
  #   nat_gateway_id = var.inspection_vpc_nat_gw_ids[count.index]
  # }
    route {
    cidr_block     = "0.0.0.0/0"
    # to Internet via CHKP
    vpc_endpoint_id = var.gwlbe_ids[count.index]
  }
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   # https://github.com/hashicorp/terraform-provider-aws/issues/16759
  #   vpc_endpoint_id = element([for ss in tolist(aws_networkfirewall_firewall.inspection_vpc_anfw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == aws_subnet.inspection_vpc_firewall_subnet[count.index].id], 0)
  # }
  tags = {
    Name = "inspection-vpc/${data.aws_availability_zones.available.names[count.index]}/tgw-subnet-route-table"
  }
}

resource "aws_route_table" "inspection_vpc_gwlbe_subnet_route_table" {
  count  = 3
  vpc_id = var.inspection_vpc_id
    route {
    cidr_block     = "0.0.0.0/0"
    # to Internet via NAT gw
    nat_gateway_id = var.inspection_vpc_nat_gw_ids[count.index]
  }
  # missing path to spokes via TGW!!! 
    route {
    cidr_block         = var.super_cidr_block
    transit_gateway_id = var.tgw_id
  }
  tags = {
    Name = "inspection-vpc/${data.aws_availability_zones.available.names[count.index]}/gwlbe-subnet-route-table"
  }
}

resource "aws_route_table" "inspection_vpc_public_subnet_route_table" {
  count  = 3// length(data.aws_availability_zones.available.names)
  vpc_id = var.inspection_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =var.igw_id
  
  }
  # back to spokes via TGW
  #  route {
  #   cidr_block         = var.super_cidr_block
  #   transit_gateway_id = var.tgw_id
  # }
  # back to spokes via CHECKPOINT
    route {
    cidr_block         = var.super_cidr_block
    vpc_endpoint_id = var.gwlbe_ids[count.index]
  }
  # route {
  #   cidr_block = var.super_cidr_block
  #   # https://github.com/hashicorp/terraform-provider-aws/issues/16759
  #   #vpc_endpoint_id = element([for ss in tolist(aws_networkfirewall_firewall.inspection_vpc_anfw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == aws_subnet.inspection_vpc_firewall_subnet[count.index].id], 0)
  #   vpc_endpoint_id = <CP gwlbe>
  # }
  tags = {
    Name = "inspection-vpc/${data.aws_availability_zones.available.names[count.index]}/public-subnet-route-table"
  }
}

resource "aws_route_table_association" "inspection_vpc_tgw_subnet_route_table_association" {
  count          = 3 //length(data.aws_availability_zones.available.names)
  route_table_id = aws_route_table.inspection_vpc_tgw_subnet_route_table[count.index].id
  subnet_id      = var.tgw_subnet_ids[count.index]
}



resource "aws_route_table_association" "inspection_vpc_public_subnet_route_table_association" {
  count          = 3 //length(data.aws_availability_zones.available.names)
  route_table_id = aws_route_table.inspection_vpc_public_subnet_route_table[count.index].id
  subnet_id      = var.public_subnet_ids[count.index]
}


resource "aws_route_table" "inspection_vpc_firewall_subnet_route_table" {
  depends_on = [ data.aws_availability_zones.available ]
  count  = 3// length(data.aws_availability_zones.available.names)
  vpc_id = var.inspection_vpc_id
  route {
    cidr_block         = var.super_cidr_block
    transit_gateway_id = var.tgw_id
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.inspection_vpc_nat_gw_ids[count.index]
  }
  tags = {
    Name = "inspection-vpc/${data.aws_availability_zones.available.names[count.index]}/firewall-subnet-route-table"
  }
}

resource "aws_route_table_association" "inspection_vpc_firewall_subnet_route_table_association" {
  count          = 3 //length(data.aws_availability_zones.available.names)
  route_table_id = aws_route_table.inspection_vpc_firewall_subnet_route_table[count.index].id
  subnet_id      = var.firewall_subnet_ids[count.index]
}



resource "aws_route_table_association" "inspection_vpc_gwlbe_subnet_route_table_association" {
  count          = 3
  route_table_id = aws_route_table.inspection_vpc_gwlbe_subnet_route_table[count.index].id
  subnet_id      = var.gwlbe_subnet_ids[count.index]
}
