module "linux" {
  source = "./linux"
  virtual_network_name = azurerm_virtual_network.vnet.name
  vnet_rg = azurerm_resource_group.rg

  myip = local.myip
  route_through_firewall = var.route_through_firewall

}

output "linux_ssh_ip" {
  value = module.linux.ssh_ip
}

output "linux_ssh_key" {
    sensitive = true
    value = module.linux.ssh_key
}

output "linux_ssh_config" {
  value = module.linux.ssh_config
}