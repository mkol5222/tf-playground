terraform {
  required_providers {
    checkpoint = {
      source = "CheckPointSW/checkpoint"
      version = "2.6.0"
    }
  }
}

provider "checkpoint" {
  server   = var.CPSERVER
  api_key  = var.CPAPIKEY
  context  = "web_api"
  cloud_mgmt_id = var.CPTENANT
  session_name = "Made by TF"
}

variable "CPSERVER" { }
variable "CPTENANT" {}
variable "CPAPIKEY" {}
  
# resource "checkpoint_management_host" "example" {
#   name = "New Host 1"
#   ipv4_address = "192.0.2.1"
# }

locals {
  hostList = jsondecode(file("./h.json"))
}

output "hostList" {
  value = local.hostList  
}

resource "checkpoint_management_host" "hostFromList" {
  for_each ={
    for index, host in local.hostList:
    host.name => host
  }
  name = each.value.name
  ipv4_address = each.value.ip
  color = each.value.color
}

variable "publish" {
  default = false
}
resource "checkpoint_management_publish" "policy" {
  count = var.publish ? 1 : 0
  triggers = [ "${timestamp()}" ]
  depends_on = [ local.hostList ]
 }