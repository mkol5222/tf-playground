variable "location" {
  default = "westeurope"
}

variable "resource_group_name" {
  default = "aks-sa-rg"
}

variable "aks_name" {
  default = "aks-sa-cluster"
}

variable "myip" {
  type=string  
}

variable "route_through_firewall" {
  type = bool
  
  default = false
}
