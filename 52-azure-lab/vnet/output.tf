
output "vnet" {
    value = azurerm_virtual_network.vnet
}

output "rg" {
  value = azurerm_resource_group.rg
}

output "aks_subnet" {
  value = azurerm_subnet.aks-subnet
}