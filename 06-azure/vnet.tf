
resource "azurerm_virtual_network" "example" {
  name                = "tf-playground-network"
  location            = data.azurerm_resource_group.playground.location
  resource_group_name = data.azurerm_resource_group.playground.name
  address_space       = ["10.0.0.0/16"]
}

output "vnet-id" {
    value = azurerm_virtual_network.example
}