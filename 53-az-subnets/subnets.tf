
locals {
  subnets    = csvdecode(file("${path.module}/subnets.csv"))
  subnet_map = { for subnet in local.subnets : subnet.name => subnet }
}

output "subnets" {
  value = local.subnets
}


resource "azurerm_subnet" "subnets" {
  for_each             = local.subnet_map
  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.cidr]
}
