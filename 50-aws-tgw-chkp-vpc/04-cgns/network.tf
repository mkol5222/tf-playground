
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

locals  {
  gwlb_service_name = "com.amazonaws.vpce.${data.aws_region.current.name}.${aws_vpc_endpoint_service.gwlb_endpoint_service.id}"
}

resource "aws_vpc_endpoint" "gwlb_endpoint1" {
  depends_on = [ aws_subnet.inspection_vpc_gwlbe_subnet[0]]
  vpc_id = var.inspection_vpc_id
  vpc_endpoint_type = "GatewayLoadBalancer"
  service_name = local.gwlb_service_name
  subnet_ids =[ aws_subnet.inspection_vpc_gwlbe_subnet[0].id]
  tags = {
    "Name" = "gwlb_endpoint1"
  }
}
resource "aws_vpc_endpoint" "gwlb_endpoint2" {
  depends_on = [ aws_subnet.inspection_vpc_gwlbe_subnet[1]]
  vpc_id = var.inspection_vpc_id
  vpc_endpoint_type = "GatewayLoadBalancer"
  service_name = local.gwlb_service_name
  subnet_ids = [aws_subnet.inspection_vpc_gwlbe_subnet[1].id]
  tags = {
    "Name" = "gwlb_endpoint2"
  }
}
resource "aws_vpc_endpoint" "gwlb_endpoint3" {
  depends_on = [ aws_subnet.inspection_vpc_gwlbe_subnet[2]]
  vpc_id = var.inspection_vpc_id
  vpc_endpoint_type = "GatewayLoadBalancer"
  service_name = local.gwlb_service_name
  subnet_ids =[ aws_subnet.inspection_vpc_gwlbe_subnet[2].id]
  tags = {
    "Name" = "gwlb_endpoint3"
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
