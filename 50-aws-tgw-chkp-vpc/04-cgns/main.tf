module "gateway_load_balancer" {
  source = "./modules/common/load_balancer"

  load_balancers_type = "gateway"
  instances_subnets = var.firewall_subnet_ids
  prefix_name = var.gateway_load_balancer_name
  internal = true

  security_groups = []
  tags = {
    x-chkp-management = var.management_server
    x-chkp-template = var.configuration_template
  }
  vpc_id = var.inspection_vpc_id
  load_balancer_protocol = "GENEVE"
  target_group_port = 6081
  listener_port = 6081
  cross_zone_load_balancing = var.enable_cross_zone_load_balancing
}

resource "aws_vpc_endpoint_service" "gwlb_endpoint_service" {
depends_on = [module.gateway_load_balancer]
  gateway_load_balancer_arns = module.gateway_load_balancer[*].load_balancer_arn
  acceptance_required        = var.connection_acceptance_required

  tags = {
    "Name" = "gwlb-endpoint-service-${var.gateway_load_balancer_name}"
  }
}

module "autoscale_gwlb" {
  source = "./modules/autoscale-gwlb"

  depends_on = [module.gateway_load_balancer]

  target_groups = module.gateway_load_balancer[*].target_group_arn
  vpc_id = var.inspection_vpc_id
  subnet_ids = var.firewall_subnet_ids
  gateway_name = var.gateway_name
  gateway_instance_type = var.gateway_instance_type
  key_name = var.ssh_key_name
  enable_volume_encryption = var.enable_volume_encryption
  enable_instance_connect = var.enable_instance_connect
  minimum_group_size = var.minimum_group_size
  maximum_group_size = var.maximum_group_size
  gateway_version = var.gateway_version
  gateway_password_hash = var.gateway_password_hash
  gateway_maintenance_mode_password_hash = var.gateway_maintenance_mode_password_hash
  gateway_SICKey = var.gateway_SICKey
  allow_upload_download = var.allow_upload_download
  enable_cloudwatch = var.enable_cloudwatch
  gateway_bootstrap_script = var.gateway_bootstrap_script
  admin_shell = var.admin_shell
  gateways_provision_address_type = var.gateways_provision_address_type
  allocate_public_IP = var.allocate_public_IP
  management_server = var.management_server
  configuration_template = var.configuration_template
  volume_type = var.volume_type
}