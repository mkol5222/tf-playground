
# resource "checkpoint_management_group" "example" {
#   name = "New Group 4"
#   members = [ "New Host 1", "My Test Host 3" ]
# }

data "http" "tags" {
  url = "http://127.0.0.1:8000/api/extras/tags/"
  request_headers = {
    "Content-Type" = "application/json"
    "Authorization" = "Token ${var.netbox_apitoken}"
  }
}

data "http" "ipam_hosts_in_group" {
    for_each = { for group in local.group_tags_list: group => group }

    url = "http://127.0.0.1:8000/api/ipam/ip-addresses/?tag=host&tag=${each.value}"
  request_headers = {
    "Content-Type" = "application/json"
    "Authorization" = "Token ${var.netbox_apitoken}"
  }
}

resource "checkpoint_management_group" "policy_groups" {
  depends_on =  [checkpoint_management_host.netbox_host]
  for_each = { for group in local.group_tags_list: group => group }
  name = "group_${each.value}"
  members = [ for host in jsondecode(data.http.ipam_hosts_in_group[each.value].body).results: host.description ]

  tags = ["netbox"]
}

locals {
    tags = jsondecode(data.http.tags.body).results
    group_tags_list = [ for tag in local.tags: tag.name if startswith(tag.name, "policy_server_")]
}

output "group_tags_list" {
    value = local.group_tags_list
}