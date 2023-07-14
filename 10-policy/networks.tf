resource "checkpoint_management_network" "vnet42" {
  name = "vnet_42"
  subnet4 = "10.42.0.0"
  mask_length4 = 16
  color = "cyan"
}

import {
    to = checkpoint_management_network.vnet43
    id = "vnet_43"
}