
resource "aws_subnet" "inspection_vpc_gwlbe_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  map_public_ip_on_launch = false
  vpc_id                  = var.inspection_vpc_id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(var.inspection_vpc_cidr, 8, 40 + count.index)
  tags = {
    Name = "inspection-vpc/${data.aws_availability_zones.available.names[count.index]}/gwlbe-subnet"
  }
}
