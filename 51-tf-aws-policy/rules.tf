resource "checkpoint_management_access_rule" "rule99" {
  layer    = "${checkpoint_management_package.gwlb.name} Network"

  position = {top = "top"}
  name     = "from all VPC"

  source = [checkpoint_management_network.vpc-all.name ]

  destination        = ["Any"]
  destination_negate = false

  service            = ["Any"]
  service_negate     = false

  action             = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }

  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}

resource "checkpoint_management_access_rule" "rule80" {
  layer    = "${checkpoint_management_package.gwlb.name} Network"

  position = {above = checkpoint_management_access_rule.rule99.id }
  name     = "E-W from hosta to hostb"

  source = [checkpoint_management_data_center_query.hosta.name ]

  destination        = [checkpoint_management_data_center_query.hostb.name ]
  destination_negate = false

  service            = ["Any"]
  service_negate     = false

  action             = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }
  
  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}

resource "checkpoint_management_access_rule" "rule79" {
  layer    = "${checkpoint_management_package.gwlb.name} Network"

  position = {above = checkpoint_management_access_rule.rule80.id }
  name     = "E-W from host-b to host-a"

  source = [checkpoint_management_data_center_query.hostb.name ]

  destination        = [checkpoint_management_data_center_query.hosta.name ]
  destination_negate = false

  service            = ["Any"]
  service_negate     = false

  action             = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }
  
  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}