
resource "aws_subnet" "inspection_vpc_gwlbe_subnet" {
  count                   = 3 // length(data.aws_availability_zones.available.names)
  map_public_ip_on_launch = false
  vpc_id                  = var.inspection_vpc_id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(var.inspection_vpc_cidr, 8, 40 + count.index)
  tags = {
    Name = "inspection-vpc/${data.aws_availability_zones.available.names[count.index]}/gwlbe-subnet"
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
  tags = {
    Name = "inspection-vpc/${data.aws_availability_zones.available.names[count.index]}/gwlbe-subnet-route-table"
  }
}

resource "aws_route_table_association" "inspection_vpc_gwlbe_subnet_route_table_association" {
  count          = 3
  route_table_id = aws_route_table.inspection_vpc_gwlbe_subnet_route_table[count.index].id
  subnet_id      = aws_subnet.inspection_vpc_gwlbe_subnet[count.index].id
}
