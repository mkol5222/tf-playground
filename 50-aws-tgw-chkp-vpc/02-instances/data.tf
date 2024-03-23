


data "aws_vpc" "spoke_vpc_a" {
  id = var.spoke_vpc_a_id
}




data "aws_vpc" "spoke_vpc_b" {
  id = var.spoke_vpc_b_id
}