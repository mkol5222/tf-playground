resource "checkpoint_management_host" "test_host" {

  name         = "host_test_123"
  ipv4_address = "1.2.3.107"

}

resource "checkpoint_management_host" "localhost" {
  name         = "localhost"
  ipv4_address = "127.0.0.1"
  color        = "blue"
}

resource "checkpoint_management_host" "linux" {
  name         = "linux"
  ipv4_address = "10.68.2.4"
  color        = "blue"
}