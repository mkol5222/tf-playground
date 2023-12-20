
resource "azurerm_virtual_network" "vnet" {
  name          = "${var.resource_group_name}-vnet"
  address_space = ["10.0.0.0/16"]

  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet" "aks-subnet" {
    name                 = "${var.resource_group_name}-aks-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.1.0.0/24"]  
}
