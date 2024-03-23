


data "aws_vpc" "spoke_vpc_a" {
  id = var.spoke_vpc_a_id
}




data "aws_vpc" "spoke_vpc_b" {
  id = var.spoke_vpc_b_id
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "amzn2-ami-hvm*"
}

data "aws_subnet" "spoke_vpc_a_protected_subnet_a" {
  id = var.spoke_vpc_a_protected_subnet_a_id
}

data "aws_subnet" "spoke_vpc_b_protected_subnet_a" {
  id = var.spoke_vpc_b_protected_subnet_a_id
}

data "aws_subnet" "spoke_vpc_a_endpoint_subnet" {
    count             = 3
    id = var.spoke_vpc_a_endpoint_subnet_ids[count.index]
}

data "aws_subnet" "spoke_vpc_b_endpoint_subnet" {
    count             = 3
    id = var.spoke_vpc_b_endpoint_subnet_ids[count.index]
}

data "aws_region" "current" {}
