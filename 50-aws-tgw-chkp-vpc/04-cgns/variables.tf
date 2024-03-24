variable "inspection_vpc_id" {}
variable "inspection_vpc_cidr" {}

variable "inspection_vpc_nat_gw_ids" {}

// GWLB
variable "firewall_subnet_ids" {}
variable "gateway_load_balancer_name" {
  default = "gwlb1"
}
variable "enable_cross_zone_load_balancing" {
    default = true
}

// management_server = "CP-Management-gwlb-tf"
variable "management_server" {
  
}
// configuration_template = "gwlb-configuration"
variable "configuration_template" {
  
}