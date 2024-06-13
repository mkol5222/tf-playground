
resource "azurerm_virtual_network" "vnet" {
  name                = "53-az-subnets-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.68.0.0/16"]


  tags = {
    environment = "demo"
  }
}