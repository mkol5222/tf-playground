module "linux" {
  source = "./linux"
  virtual_network_name = module.vnet.vnet.name
  vnet_rg = module.vnet.rg

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