terraform {
  required_providers {
    checkpoint = {
      source  = "CheckPointSW/checkpoint"
      version = "2.5.1"
    }
  }
}
provider "checkpoint" {
  server        = var.CPSERVER
  api_key       = var.CPKEY
  context       = "web_api"
  cloud_mgmt_id = var.CPID
}

variable "CPSERVER" {
  
}
variable "CPKEY" {
  
}
variable "CPID" {
  
}

