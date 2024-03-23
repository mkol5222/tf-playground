

module "env" {
    source = "./01-env"
}

module "instances" {
    source = "./02-instances"
    spoke_vpc_a_id = module.env.spoke_vpc_a_id
    spoke_vpc_b_id = module.env.spoke_vpc_b_id
}