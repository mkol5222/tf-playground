resource "checkpoint_management_host" "spoke-a-host" {
    name ="spoke-a-host"
    ipv4_address = "10.10.10.10"
    color = "blue"
}

resource "checkpoint_management_host" "spoke-b-host" {
    name ="spoke-b-host"
    ipv4_address = "10.11.10.11"
    color = "orange"
}

resource "checkpoint_management_host" "pat" {
    name ="pat"
    ipv4_address = "192.168.10.11"
    color = "blue"
}