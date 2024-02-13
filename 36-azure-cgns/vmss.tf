# https://github.com/CheckPointSW/CloudGuardIaaS/tree/master/terraform/azure/vmss-existing-vnet

module "vmss" {
  // depends_on = [ azurerm_subnet.cp-back, azurerm_subnet.cp-front ]

  source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/vmss-existing-vnet"

  client_secret   = var.client_secret
  client_id       = var.client_id
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

  source_image_vhd_uri = "noCustomUri"

  resource_group_name = "cp-vmss-tf"
  location            = "westeurope"
  vmss_name           = "cp-vmss-tf"

  vnet_name           = "checkpoint-mgmt-vnet"
  vnet_resource_group = "cp-man-tf"

  frontend_subnet_name = azurerm_subnet.cp-front.name
  backend_subnet_name  = azurerm_subnet.cp-back.name

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
  management_name                = "cp-man-tf"
  management_IP                  = "10.0.0.4"
  management_interface           = "eth0-private"
  configuration_template_name    = "vmss_template"
  notification_email             = ""
  frontend_load_distribution     = "Default"
  backend_load_distribution      = "Default"
  enable_custom_metrics          = false
  enable_floating_ip             = false
  deployment_mode                = "Standard"
  admin_shell                    = "/bin/bash"
  serial_console_password_hash   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  maintenance_mode_password_hash = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}