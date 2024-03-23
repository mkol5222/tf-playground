

module "env" {
    source = "./01-env"
}

module "instances" {

    depends_on = [ module.env ]

    source = "./02-instances"
    spoke_vpc_a_id = module.env.spoke_vpc_a_id
    spoke_vpc_b_id = module.env.spoke_vpc_b_id
    spoke_vpc_a_protected_subnet_a_id = module.env.spoke_vpc_a_protected_subnet_a_id
    spoke_vpc_b_protected_subnet_a_id = module.env.spoke_vpc_b_protected_subnet_a_id
}

output "spoke_vpc_a_host_ip" {
  value = module.instances.spoke_vpc_a_host_ip
}

output "spoke_vpc_b_host_ip" {
  value = module.instances.spoke_vpc_b_host_ip
}