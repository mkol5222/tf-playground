resource "checkpoint_management_host" "example" {
  name         = "martin-pol"
  ipv4_address = "192.0.2.79"
  color = "red"
}

resource "checkpoint_management_host" "h1" {
  name         = "h1"
  ipv4_address = "192.0.2.201"
  color = "cyan"
}

resource "checkpoint_management_host" "h2" {
  name         = "h2"
  ipv4_address = "192.0.2.202"
  color = "blue"
}

resource "checkpoint_management_host" "h3" {
  name         = "h3"
  ipv4_address = "192.0.2.203"
  color = "blue"
}

resource "checkpoint_management_host" "h4" {
  name         = "h4"
  ipv4_address = "192.0.2.204"
  color = "blue"
}

import {
    to = checkpoint_management_host.martin_import
    id = "martin-import"
}