variable "rg" {
    default = "57-logexporter"
}

variable "location" {
    default = "westeurope"
}

variable "vnet_name" {
    default = "57-logexporter"
}

variable "vnet_cidr" {
    default = "10.42.0.0/16"
}

variable "logexporter_subnet_cird" {
    default = "10.42.10.0/24"
}

variable "vm_name" {
    default = "logexporter"
}



