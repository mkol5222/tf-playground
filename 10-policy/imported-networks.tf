# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "vnet_43"
resource "checkpoint_management_network" "vnet43" {
  broadcast       = "allow"
  color           = "black"
  comments        = null
  ignore_errors   = null
  ignore_warnings = null
  mask_length4    = 16
  mask_length6    = null
  name            = "vnet_43"
  nat_settings = {
    auto_rule   = "true"
    hide_behind = "gateway"
    install_on  = "All"
    method      = "hide"
  }
  subnet4 = "10.43.0.0"
  subnet6 = null
  tags    = []
}
