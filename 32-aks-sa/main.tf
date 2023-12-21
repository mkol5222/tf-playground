module "aks" {
  source = "./aks"
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