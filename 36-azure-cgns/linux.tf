module "linux" {
  source = "./linux-vm"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  vnet_rg = data.azurerm_virtual_network.vnet.resource_group_name

    myip = local.myip
  route_through_firewall = false

    depends_on = [ module.management ]
}

output "linux_key" {
  value = module.linux.ssh_key
  sensitive = true
}

output "linux_ssh_config" {
  value = module.linux.ssh_config
}