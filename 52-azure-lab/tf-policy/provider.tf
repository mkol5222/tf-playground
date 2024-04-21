terraform {
  required_providers {
    checkpoint = {
      source = "CheckPointSW/checkpoint"
      version = "2.7.0"
    }
  }
}

provider "checkpoint" {
  # Configuration options
  server   = var.cpserver
  api_key  = var.cpapikey
  #cloud_mgmt_id = "de9a9b08-c7c7-436e-a64a-a54136301701"
  context  = "web_api"
}

variable "cpserver" {}
variable "cpapikey" {}