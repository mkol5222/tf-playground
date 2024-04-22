

resource "azurerm_network_security_group" "nsg" {
  for_each = local.subnet_map

  name                = "${each.key}-subnet-ngs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each =  { for subnet in values(local.subnet_map): subnet.name => subnet if subnet.app == each.value.app }
     iterator = subnet
    content {
      name                       = "${subnet.key}-inbound"
      #priority                   = 1001
       priority            = (index(keys(local.subnet_map), subnet.key) + 1100)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = subnet.value.cidr
      destination_address_prefix = "*"
    }
  }

// DenyVnetInBound
  security_rule {
    name                       = "DenyVnetInbound"
    priority                   = 2999
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg2subnet" {
    for_each = local.subnet_map
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
