# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "martin-import"
resource "checkpoint_management_host" "martin_import" {
  color           = "cyan"
  comments        = null
  ignore_errors   = null
  ignore_warnings = null
  ipv4_address    = "1.2.3.100"
  ipv6_address    = null
  name            = "martin-import"
  nat_settings = {
    auto_rule   = "true"
    hide_behind = "gateway"
    install_on  = "All"
    method      = "hide"
  }
  tags = []
}
