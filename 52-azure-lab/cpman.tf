


resource "azurerm_subnet" "cpman_subnet" {
    name                 = "${var.resource_group_name}-cpman-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.68.107.0/24"]  
}

# https://github.com/CheckPointSW/CloudGuardIaaS/tree/master/terraform/azure/management-existing-vnet
module "cpman" {
    // depends_on = [ azurerm_subnet.cpman_subnet ]
  source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/management-existing-vnet"

  client_secret                  = var.client_secret
  client_id                      = var.client_id
  tenant_id                      = var.tenant_id
  subscription_id                = var.subscription_id
  source_image_vhd_uri           = "noCustomUri"
  resource_group_name            = "${var.resource_group_name}-cpman-rg"
  mgmt_name                      = "cpman"
  location                       = var.location

  vnet_name                      =  azurerm_virtual_network.vnet.name
  vnet_resource_group            = azurerm_resource_group.rg.name
  management_subnet_name         = "${var.resource_group_name}-cpman-subnet" //azurerm_subnet.cpman_subnet.name

  subnet_1st_Address             = "10.68.107.4"

  management_GUI_client_network  = "0.0.0.0/0"

  mgmt_enable_api                = "all"

  admin_password                 = var.cpadmin_password

  vm_size                        = "Standard_D3_v2"
  disk_size                      = "110"
  vm_os_sku                      = "mgmt-byol"
  vm_os_offer                    = "check-point-cg-r8120"

  os_version                     = "R8120"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"

  allow_upload_download          = true
  authentication_type            = "Password"
  admin_shell                    = "/bin/bash"
  
  serial_console_password_hash   = ""
  maintenance_mode_password_hash = ""
}
