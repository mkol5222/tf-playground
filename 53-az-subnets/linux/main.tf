
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vm_name}-pip"
  location            = var.rg.location
  resource_group_name = var.rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "azure-demo"
  }
  
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-ngs"
  location            = var.rg.location
  resource_group_name = var.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.myip}/32"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "web"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
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


resource "azurerm_network_interface" "nic" {
  depends_on = [
    var.subnet
  ]
  name                = "${var.vm_name}-nic"
  location            = var.rg.location
  resource_group_name = var.rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    # resource_group = data.azurerm_resource_group.rg.name
    vm_name = var.vm_name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "storage" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = var.rg.location
  resource_group_name      = var.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

}



resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                  = var.vm_name
  location              = var.rg.location
  resource_group_name   = var.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "${var.vm_name}-myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

// MY_VM_IMAGE="Canonical:0001-com-ubuntu-minimal-jammy:minimal-22_04-lts-gen2:latest"
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-jammy"
    sku       = "minimal-22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = var.vm_name
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_key.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

   tags = {
    app = "linux"
    appname = "${var.vm_name}"
  }

}
