variable "inspection_vpc_id" {}
variable "inspection_vpc_nat_gw_ids" {}
variable "tgw_subnet_ids" {}
variable "firewall_subnet_ids" {}
variable "gwlbe_subnet_ids" {}

variable "gwlbe_ids" {}

variable "super_cidr_block" {
  type    = string
  default = "10.0.0.0/8"
}

variable "igw_id" {
  
}

variable "tgw_id" {
  
}

variable "public_subnet_ids" {
  
}