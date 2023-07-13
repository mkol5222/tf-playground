# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "net-import"
resource "checkpoint_management_network" "net_import" {
  broadcast       = "allow"
  color           = "orange"
  comments        = null
  ignore_errors   = null
  ignore_warnings = null
  mask_length4    = 16
  mask_length6    = null
  name            = "net-import"
  nat_settings    = {}
  subnet4         = "172.16.0.0"
  subnet6         = null
  tags            = []
}
