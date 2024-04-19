

resource "checkpoint_management_host" "netbox_host" {
    for_each = local.hosts_map
    name = each.key
    ipv4_address = each.value
  
}