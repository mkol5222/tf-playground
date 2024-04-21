resource "checkpoint_management_access_rule" "from_net_linux" {
  layer    = "${checkpoint_management_package.package.name} Network"
  //position = { above = checkpoint_management_access_rule.rule900.id }
  position = { top = "top" }
  name     = "from Linux subnet"

  source   = [checkpoint_management_network.net-linux.name]
  
  enabled            = true

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

resource "checkpoint_management_access_rule" "from_dc1_app_linux1" {
  layer    = "${checkpoint_management_package.package.name} Network"
  position = { above = checkpoint_management_access_rule.from_net_linux.id }
  
  name     = "from app=linux1"

  source   = [checkpoint_management_data_center_query.appLinux1.name]
  
  enabled            = true

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