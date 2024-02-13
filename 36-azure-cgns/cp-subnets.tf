

data "azurerm_virtual_network" "vnet" {
    name = "checkpoint-mgmt-vnet"
    resource_group_name = "cp-man-tf"
}

resource "azurerm_subnet" "cp-front" {
    name                 = "cp-front"
    resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
    virtual_network_name = data.azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.10.0/24"]  
}

resource "azurerm_subnet" "cp-back" {
    name                 = "cp-back"
    resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
    virtual_network_name = data.azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.11.0/24"]  
}

