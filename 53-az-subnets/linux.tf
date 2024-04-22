

module "linux" {
    for_each = local.subnet_map

    source = "./linux"

    myip = local.myip
    rg = azurerm_resource_group.rg
    vm_name = each.key
    ssh_key = tls_private_key.linux_ssh
    subnet = azurerm_subnet.subnets[each.key]
}