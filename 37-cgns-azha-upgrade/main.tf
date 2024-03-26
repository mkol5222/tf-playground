

module "vnet" {
  source = "./vnet"
}

module "cpha1" {
  // depends_on = [ azurerm_subnet.cp-back, azurerm_subnet.cp-front ]

  source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/high-availability-existing-vnet"

  client_secret   = var.client_secret
  client_id       = var.client_id
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

  source_image_vhd_uri = "noCustomUri"
  resource_group_name  = "cpha1"
  cluster_name         = "cpha1"
  location             = "westeurope"

  vnet_name                      = "cgns-azha-upgrade-vnet"
  vnet_resource_group            = "cgns-azha-upgrade-rg"
  frontend_subnet_name           = "cgns-azha-upgrade-cp-front-subnet"
  backend_subnet_name            = "cgns-azha-upgrade-cp-back-subnet"
  frontend_IP_addresses          = [4, 5, 6]
  backend_IP_addresses           = [4, 5, 6]
  admin_password                 = "Welcome@Home#1984"
 smart_1_cloud_token_a          = "aHR0cHM6Ly9jbG91ZGluZnJhLWd3LnBvcnRhbC5jaGVja3BvaW50LmNvbS9hcHAvbWFhcy9hcGkvdjEvdGVuYW50LzgxNjNlMGI2LWYyNzktNDdmMy1hMjE2LTNjMjg0YjlhMTUxZC9hY2Nlc3Mta2V5cy8/b3RwPTA3NTg3ZjYyLTA0OGQtNGU3Ny1hYTcwLWJmMjE0MWY5ZTQxMA=="
  smart_1_cloud_token_b          = "aHR0cHM6Ly9jbG91ZGluZnJhLWd3LnBvcnRhbC5jaGVja3BvaW50LmNvbS9hcHAvbWFhcy9hcGkvdjEvdGVuYW50LzgxNjNlMGI2LWYyNzktNDdmMy1hMjE2LTNjMjg0YjlhMTUxZC9hY2Nlc3Mta2V5cy8/b3RwPTlhODU4ZTMyLWU3YTAtNGQ1NC04MWFjLWEzMDQwNDNhYWZhZg=="
   sic_key                        = "WelcomeHome1984"
  vm_size                        = "Standard_D3_v2"
  disk_size                      = "110"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r8120"
  os_version                     = "R8110"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  allow_upload_download          = true
  authentication_type            = "Password"
  availability_type              = "Availability Zone"
  enable_custom_metrics          = true
  enable_floating_ip             = false
  use_public_ip_prefix           = false
  create_public_ip_prefix        = false
  existing_public_ip_prefix_id   = ""
  admin_shell                    = "/bin/bash"
  serial_console_password_hash   = "$6$vNoQjEAqeNGDlVeA$/JDrwLCKvxdw0yhcatSmumPzqu0fWezYAA0fXLzTpuWZfWzfufiF53fJeFAqx5wSftcCDd7STpbevQHhnw48l." // openssl passwd -6 "Welcome@Home#1984"
  maintenance_mode_password_hash = ""                                                                                                           // grub2-mkpasswd-pbkdf2

}

module "cpha2" {
  // depends_on = [ azurerm_subnet.cp-back, azurerm_subnet.cp-front ]

// MKo fork!
  source = "github.com/mkol5222/CloudGuardIaaS/terraform/azure/high-availability-existing-vnet"

  no_frontend_lb = true
  no_backend_lb = true

  client_secret   = var.client_secret
  client_id       = var.client_id
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

  source_image_vhd_uri = "noCustomUri"
  resource_group_name  = "cpha2"
  cluster_name         = "cpha2"
  location             = "westeurope"

  vnet_name                      = "cgns-azha-upgrade-vnet"
  vnet_resource_group            = "cgns-azha-upgrade-rg"
  frontend_subnet_name           = "cgns-azha-upgrade-cp-front-subnet"
  backend_subnet_name            = "cgns-azha-upgrade-cp-back-subnet"
  frontend_IP_addresses          = [8,9,10]
  backend_IP_addresses           = [8,9,10]

  admin_password                 = "Welcome@Home#1984"
  smart_1_cloud_token_a          = "aHR0cHM6Ly9jbG91ZGluZnJhLWd3LnBvcnRhbC5jaGVja3BvaW50LmNvbS9hcHAvbWFhcy9hcGkvdjEvdGVuYW50LzgxNjNlMGI2LWYyNzktNDdmMy1hMjE2LTNjMjg0YjlhMTUxZC9hY2Nlc3Mta2V5cy8/b3RwPTA3NTg3ZjYyLTA0OGQtNGU3Ny1hYTcwLWJmMjE0MWY5ZTQxMA=="
  smart_1_cloud_token_b          = "aHR0cHM6Ly9jbG91ZGluZnJhLWd3LnBvcnRhbC5jaGVja3BvaW50LmNvbS9hcHAvbWFhcy9hcGkvdjEvdGVuYW50LzgxNjNlMGI2LWYyNzktNDdmMy1hMjE2LTNjMjg0YjlhMTUxZC9hY2Nlc3Mta2V5cy8/b3RwPTlhODU4ZTMyLWU3YTAtNGQ1NC04MWFjLWEzMDQwNDNhYWZhZg=="
  sic_key                        = "WelcomeHome1984"
  vm_size                        = "Standard_D3_v2"
  disk_size                      = "110"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r8120"
  os_version                     = "R8120"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  allow_upload_download          = true
  authentication_type            = "Password"
  availability_type              = "Availability Zone"
  enable_custom_metrics          = true
  enable_floating_ip             = false
  use_public_ip_prefix           = false
  create_public_ip_prefix        = false
  existing_public_ip_prefix_id   = ""
  admin_shell                    = "/bin/bash"
  serial_console_password_hash   = "$6$vNoQjEAqeNGDlVeA$/JDrwLCKvxdw0yhcatSmumPzqu0fWezYAA0fXLzTpuWZfWzfufiF53fJeFAqx5wSftcCDd7STpbevQHhnw48l." // openssl passwd -6 "Welcome@Home#1984"
  maintenance_mode_password_hash = ""                                                                                                           // grub2-mkpasswd-pbkdf2

}

module "linux" {
  source                 = "./linux-vm"
  myip                   = local.myip
  route_through_firewall = true
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # version = "3.93.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}

// management station IP
data "http" "myip" {
  url = "http://ip.iol.cz/ip/"
}

locals {
  myip = data.http.myip.response_body
}

output "myip" {
  value = local.myip
}