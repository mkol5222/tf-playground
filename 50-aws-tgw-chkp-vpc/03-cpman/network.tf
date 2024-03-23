
resource "aws_subnet" "inspection_vpc_cpman_subnet" {

  map_public_ip_on_launch = true
  vpc_id                  = var.inspection_vpc_id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = "10.255.77.0/24"
  
  tags = {
    Name = "inspection-vpc/cpman-subnet"
  }
}

resource "aws_route_table" "inspection_vpc_cpman_subnet_route_table" {

  vpc_id = var.inspection_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  
  }
#   # back to spokes via TGW
#    route {
#     cidr_block         = var.super_cidr_block
#     transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#   }
  # route {
  #   cidr_block = var.super_cidr_block
  #   # https://github.com/hashicorp/terraform-provider-aws/issues/16759
  #   vpc_endpoint_id = element([for ss in tolist(aws_networkfirewall_firewall.inspection_vpc_anfw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == aws_subnet.inspection_vpc_firewall_subnet[count.index].id], 0)
  # }
  tags = {
    Name = "inspection-vpc/cpman-subnet-route-table"
  }
}

resource "aws_route_table_association" "inspection_vpc_cpman_subnet_route_table_association" {

  route_table_id = aws_route_table.inspection_vpc_cpman_subnet_route_table.id
  subnet_id      = aws_subnet.inspection_vpc_cpman_subnet.id
}
