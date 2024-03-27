
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


