resource "checkpoint_management_network" "vpc-all" {
  name            = "net-vpc-all"
  subnet4         = "10.0.0.0"
  mask_length4    = 8
  ignore_warnings = true
}

resource "checkpoint_management_network" "vpc-spoke-a" {
  name            = "net-spoke-a"
  subnet4         = "10.10.0.0"
  mask_length4    = 16
  ignore_warnings = true
}

resource "checkpoint_management_network" "vpc-spoke-b" {
  name            = "net-spoke-b"
  subnet4         = "10.11.0.0"
  mask_length4    = 16
  ignore_warnings = true
}

resource "checkpoint_management_network" "vpc-inspection" {
  name            = "net-inspection"
  subnet4         = "10.255.0.0"
  mask_length4    = 16
  ignore_warnings = true
}

resource "checkpoint_management_network" "brain" {
      broadcast    = "allow"
    color        = "orange"
   
    mask_length4 = 24
    name         = "net-brain"
    nat_settings = {
        "auto_rule"   = "true"
        "hide_behind" = "gateway"
        "install_on"  = "All"
        "method"      = "hide"
    }
    subnet4      = "192.168.77.0"
    tags         = []
}
