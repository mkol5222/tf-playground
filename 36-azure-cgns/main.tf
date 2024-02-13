
module "management" {
    source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/management-new-vnet"

    client_secret                   = var.client_secret
    client_id                       = var.client_id
    tenant_id                       = var.tenant_id
    subscription_id                 = var.subscription_id
    source_image_vhd_uri            = "noCustomUri"
    resource_group_name             = "cp-man-tf"
    mgmt_name                       = "cp-man-tf"
    location                        = "westeurope"
    vnet_name                       = "checkpoint-mgmt-vnet"
    address_space                   = "10.0.0.0/16"
    subnet_prefix                   = "10.0.0.0/24"
    management_GUI_client_network   = "0.0.0.0/0"
    mgmt_enable_api                 = "disable"
    admin_password                  = "Welcome@Home#1984"
    vm_size                         = "Standard_D3_v2"
    disk_size                       = "110"
    vm_os_sku                       = "mgmt-byol"
    vm_os_offer                     = "check-point-cg-r8120"
    os_version                      = "R8120"
    bootstrap_script                = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
    allow_upload_download           = true
    authentication_type             = "Password"
    admin_shell                     = "/bin/bash"
    serial_console_password_hash    = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    maintenance_mode_password_hash  = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

variable "client_id" {
    type = string
}
variable "client_secret" {
    type = string
}
variable "tenant_id" {
    type = string
}
variable "subscription_id" {
    type = string
}

