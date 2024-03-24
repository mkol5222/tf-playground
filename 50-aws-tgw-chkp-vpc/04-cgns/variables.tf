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
variable "connection_acceptance_required" {
    default = false
}

// management_server = "CP-Management-gwlb-tf"
variable "management_server" {
  
}
// configuration_template = "gwlb-configuration"
variable "configuration_template" {
  
}

// Autoscale GW
variable "gateway_name" {
  default = "cpgw1"
}
variable "gateway_instance_type" {
  default =  "c5.xlarge"
}

variable "minimum_group_size" {
  default = 3
}

variable "maximum_group_size" {
  default = 6
}

variable "gateway_version" {
  default = "R81.20-BYOL"
}

variable "ssh_key_name" {

}

variable "enable_volume_encryption" {
  default = true
}

variable "enable_instance_connect" {
  default = false
}

variable "volume_type" {
  default = "gp2"
}

variable "allocate_public_IP" {
  default = false
}

variable "gateways_provision_address_type" {
  default = "private"
}

variable "admin_shell" {
  default = "/bin/bash"
}

variable "gateway_bootstrap_script" {
  default = ""
}

variable "enable_cloudwatch" {
  default = false
}

variable "allow_upload_download" {
  default = true
}

variable "gateway_SICKey" {
  
}

variable "gateway_password_hash" {
  
}

variable "gateway_maintenance_mode_password_hash" {
  
}