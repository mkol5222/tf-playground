
resource "azurerm_subnet" "frontend" {
    name                 = "frontend"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.68.201.0/24"]  
}

resource "azurerm_subnet" "backend" {
    name                 = "backend"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.68.202.0/24"]  
}

module "vmss" {

  source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/vmss-existing-vnet"

  client_secret                  = var.client_secret
  client_id                      = var.client_id
  tenant_id                      = var.tenant_id
  subscription_id                = var.subscription_id
  source_image_vhd_uri           = "noCustomUri"
  
  resource_group_name            = "${var.resource_group_name}-cpvmss-rg"
  location                       = var.location
  vmss_name                      = "cpvmss"

  vnet_name                      = azurerm_virtual_network.vnet.name
  vnet_resource_group            = azurerm_resource_group.rg.name
  frontend_subnet_name           = "frontend"
  backend_subnet_name            = "backend"
  backend_lb_IP_address          = 4

  admin_password                 = "Welcome@Home#1984"
  sic_key                        = "WelcomeHome1984"

  vm_size                        = "Standard_D3_v2"
  disk_size                      = "110"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r8120"
  os_version                     = "R8120"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  allow_upload_download          = true
  authentication_type            = "Password"
  availability_zones_num         = "1"
  minimum_number_of_vm_instances = 1
  maximum_number_of_vm_instances = 2
  management_name                = "mgmt"
  management_IP                  = "23.97.210.27"
  management_interface           = "eth1-private"
  configuration_template_name    = "vmss_template"
  notification_email             = ""
  frontend_load_distribution     = "Default"
  backend_load_distribution      = "Default"
  enable_custom_metrics          = true
  enable_floating_ip             = false
  deployment_mode                = "Standard"
  admin_shell                    = "/bin/bash"
  serial_console_password_hash   = ""
  maintenance_mode_password_hash = ""
}
