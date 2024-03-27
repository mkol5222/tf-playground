resource "checkpoint_management_host" "spoke-a-host" {
    name ="spoke-a-host"
    ipv4_address = "10.10.10.10"
    color = "blue"
}

resource "checkpoint_management_host" "spoke-b-host" {
    name ="spoke-b-host"
    ipv4_address = "10.10.11.11"
    color = "orange"
}