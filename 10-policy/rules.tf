resource "checkpoint_management_access_rule" "rule100" {
  layer       = "${checkpoint_management_package.azure.name} Network"
  position    = { top = "top" }
  name        = "from VNET"
  source      = [checkpoint_management_network.vnet42.name]
  destination = ["Any"]
  service     = ["Any"]
  action      = "Accept"
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
resource "checkpoint_management_access_rule" "rule90" {
  layer       = "${checkpoint_management_package.azure.name} Network"
  position    = { above = checkpoint_management_access_rule.rule100.id }
  name        = "to VNET"
  source = ["Any"]
  destination      = [checkpoint_management_network.vnet42.name]
  service     = ["Any"]
  action      = "Accept"
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