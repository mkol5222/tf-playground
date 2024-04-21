variable "resource_group_name" {
    default = "52-azure-lab"
}

variable "location" {
    default = "westeurope"
}

variable "route_through_firewall" {
  type = bool
  
  default = false
}

variable "myip" {
  type=string  
}