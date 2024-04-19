# variable "subscription_id" {
#   description = "The Azure subscription ID"
#   type        = string
# }

# variable "tenant_id" {
#   description = "The Azure tenant ID"
#   type        = string
# }

# variable "client_id" {
#   description = "The Azure SP client ID"
#   type        = string
# }

# variable "client_secret" {
#   description = "The Azure SP client secret"
#   type        = string
# }

variable "resource_group_name" {
  description = "Resource Group for network environment"
  type        = string
  default     = "aks-policy-linux"
}

variable "location" {
  description = "RG location"
  type        = string
  default     = "westeurope"
}

variable "virtual_network_name" {
  type = string
}

variable "vnet_rg" {
}

variable "linux-subnet-name" {
  description = "value for the name of the linux subnet"
  type        = string
  default = "linux-subnet"
}

variable "vm_name" {
  description = "value for the name of the virtual machine"
  type        = string
  default = "linux1"
}

variable "myip" {
  type=string  
}

variable "route_through_firewall" {
  type = bool
  
  default = false
}