module "linux" {
  source = "./linux"
  virtual_network_name = module.vnet.vnet.name
  vnet_rg = module.vnet.rg

  myip = local.myip
  route_through_firewall = var.route_through_firewall

}

