module "vnet" {
  source = "./vnet"

  resource_group_name = var.resource_group_name
  location = var.location
  route_through_firewall = var.route_through_firewall

    myip = local.myip
}