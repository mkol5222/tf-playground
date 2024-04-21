
resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location
}

output "vnet_rg" {
  value = azurerm_resource_group.rg
}


