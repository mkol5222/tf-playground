variable "netbox_apitoken" {
    default = "0d5b4d5f9dacc2937a94627cb26b71e750739ed8"
}
data "http" "ipam_hosts" {
  url = "http://127.0.0.1:8000/api/ipam/ip-addresses/?tag=host"
  request_headers = {
    "Content-Type" = "application/json"
    "Authorization" = "Token ${var.netbox_apitoken}"
  }
}

locals {
    hosts = jsondecode(data.http.ipam_hosts.body).results
    hosts_map = {
        for index, host in local.hosts:
            host.description => split("/",host.address)[0]
  }
}

output "hosts" {
  value = local.hosts
}

output "hosts_map" {
  value = local.hosts_map
}