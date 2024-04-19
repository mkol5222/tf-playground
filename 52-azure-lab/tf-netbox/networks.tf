

# https://registry.terraform.io/providers/CheckPointSW/checkpoint/latest/docs/resources/checkpoint_management_network

resource "checkpoint_management_network" "netbox_network" {
    for_each = local.networks_map
    name = "net_${each.key}"
    subnet4 = each.value.subnet4
    mask_length4 = each.value.mask_length4
  
}

data "http" "ipam_networks" {
  url = "http://127.0.0.1:8000/api/ipam/ip-addresses/?tag=net"
  request_headers = {
    "Content-Type" = "application/json"
    "Authorization" = "Token ${var.netbox_apitoken}"
  }
}

locals {
    networks = jsondecode(data.http.ipam_networks.body).results
    networks_map = {
        for index, network in local.networks:
            network.description => {
                subnet4 = split("/",network.address)[0]
                mask_length4 = split("/",network.address)[1]
            }
  }
}


output "networks" {
  value = local.networks_map
}