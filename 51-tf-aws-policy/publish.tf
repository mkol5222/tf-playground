resource "checkpoint_management_publish" "example" {
  count    = var.publish ? 1 : 0
  triggers = ["${timestamp()}"]

  depends_on = [checkpoint_management_host.spoke-a-host, checkpoint_management_host.spoke-b-host,

    checkpoint_management_network.vpc-all,
    checkpoint_management_network.vpc-spoke-a, checkpoint_management_network.vpc-spoke-b,
    checkpoint_management_network.vpc-inspection,
    checkpoint_management_package.gwlb,
    checkpoint_management_access_rule.rule99,
    checkpoint_management_access_rule.rule80,
    checkpoint_management_access_rule.rule79,

    checkpoint_management_aws_data_center_server.aws,
    checkpoint_management_data_center_query.hosta,
    checkpoint_management_data_center_query.hostb
  ]
}
