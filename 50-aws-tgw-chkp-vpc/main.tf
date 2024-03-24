

module "env" {
  source = "./01-env"
}

module "instances" {

  depends_on = [module.env]

  source                            = "./02-instances"
  spoke_vpc_a_id                    = module.env.spoke_vpc_a_id
  spoke_vpc_b_id                    = module.env.spoke_vpc_b_id
  spoke_vpc_a_protected_subnet_a_id = module.env.spoke_vpc_a_protected_subnet_a_id
  spoke_vpc_b_protected_subnet_a_id = module.env.spoke_vpc_b_protected_subnet_a_id

  spoke_vpc_a_endpoint_subnet_ids = module.env.spoke_vpc_a_endpoint_subnet_ids
  spoke_vpc_b_endpoint_subnet_ids = module.env.spoke_vpc_b_endpoint_subnet_ids
}

output "spoke_vpc_a_host_ip" {
  value = module.instances.spoke_vpc_a_host_ip
}

output "spoke_vpc_b_host_ip" {
  value = module.instances.spoke_vpc_b_host_ip
}

module "cpman" {
  depends_on = [module.env]

  source = "./03-cpman"

  inspection_vpc_id = module.env.inspection_vpc_id
  igw_id = module.env.igw_id
}

module "cgns" {
    depends_on = [ module.cpman ]
    source = "./04-cgns"

    inspection_vpc_id = module.env.inspection_vpc_id
    inspection_vpc_cidr =module.env.inspection_vpc_cidr
    inspection_vpc_nat_gw_ids = module.env.inspection_vpc_nat_gw_ids

    firewall_subnet_ids = module.env.firewall_subnet_ids

// GWLB
  enable_cross_zone_load_balancing = true
    // CME
  management_server = "CP-Management-gwlb-tf"
  configuration_template = "gwlb-configuration"

  // GWs
  gateway_name = "cpgwtf"
  gateway_instance_type = "c5.xlarge"
  minimum_group_size = 3
  maximum_group_size = 6
  gateway_version = "R81.20-BYOL"
  // openssl passwd -6 "password"
  gateway_password_hash = "$6$ycLB31kh2cbEDSnk$b1ZMkobMX/RUXmDWKDWnr2fPpWaGyMAZHyjg0tFrggUA6ehd8YglKyj3H0hyYCNQrgzXn89TohVj1qW2l3LoI0"
  gateway_maintenance_mode_password_hash = "" # For R81.10 and below the gateway_password_hash is used also as maintenance-mode password.
  ssh_key_name = "azureshell"

  gateway_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
  admin_shell = "/bin/bash"


  gateway_SICKey = "WelcomeHome1984"
}