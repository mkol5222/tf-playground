variable "location" {
  default = "westeurope"
}

variable "resource_group_name" {
  default = "lab-52-aks"
}

variable "aks_name" {
  default = "aksdemo"
}

variable "myip" {
  type=string  
}

variable "route_through_firewall" {
  type = bool
  
  default = false
}
