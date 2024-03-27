
resource "checkpoint_management_data_center_query" "hosta" {

  name         = "host-a"
  data_centers = [checkpoint_management_aws_data_center_server.aws.name]

  query_rules {
    key_type = "tag"
    key      = "Name"
    values   = ["spoke-vpc-a/host"]
  }

  lifecycle {
    ignore_changes = [

      query_rules,
    ]
  }

}

resource "checkpoint_management_data_center_query" "hostb" {

  name         = "host-b"
  data_centers = [checkpoint_management_aws_data_center_server.aws.name]

  query_rules {
    key_type = "tag"
    key      = "Name"
    values   = ["spoke-vpc-b/host"]
  }

  lifecycle {
    ignore_changes = [

      query_rules,
    ]
  }

}


resource "checkpoint_management_aws_data_center_server" "aws" {
 
    authentication_method  = "role-authentication"
    color                  = "orange"
    enable_sts_assume_role = false

    name                   = "aws"
    region                 = "eu-west-1"
    tags                   = []
}