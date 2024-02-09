locals {
  via_fw = false
}

module "aks" {
  source = "./aks"
  myip = local.myip
  route_through_firewall = local.via_fw
  //resource_group_name = "rg-demo-aks-jan25"
}

module "sa" {
    source = "./sa-k8s"
    k8s_host = module.aks.kubeconfig_data[0]["host"]
    k8s_client_certificate = base64decode (module.aks.kubeconfig_data[0]["client_certificate"])
    k8s_client_key = base64decode(module.aks.kubeconfig_data[0]["client_key"])
    k8s_cluster_ca_certificate = base64decode(module.aks.kubeconfig_data[0]["cluster_ca_certificate"])
}

output "kubeconfig" {
  value     = module.aks.kubeconfig
  sensitive = true
}
output "kubeconfig_data" {
  value     = module.aks.kubeconfig_data
  sensitive = true
}
output "sa_token" {
  value = module.sa.sa_token
  sensitive = true
}

output "api_server" {
  sensitive = true
  value = module.aks.kubeconfig_data[0]["host"]
}

output "api_server_cacert" {
  sensitive = true
  value = base64decode(module.aks.kubeconfig_data[0]["cluster_ca_certificate"])
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

module "linux" {
  source = "./linux-vm"
  virtual_network_name = module.aks.vnet_name
  vnet_rg = module.aks.vnet_rg

    myip = local.myip
  route_through_firewall = local.via_fw
}

output "linux_key" {
  value = module.linux.ssh_key
  sensitive = true
}

output "linux_ssh_config" {
  value = module.linux.ssh_config
}


module "cp" {
  source = "./checkpoint"
  vnet_rg = module.aks.vnet_rg
  admin_password = "welcome@home#1984"
  virtual_network_name =  module.aks.vnet_name
}

output "initscript" {
  value = module.cp.initscript
  
}

// management station IP
data "http" "myip" {
  url = "http://ip.iol.cz/ip/"
}

locals {
  myip = data.http.myip.response_body
}

output "myip" {
  value = data.http.myip.response_body
}
