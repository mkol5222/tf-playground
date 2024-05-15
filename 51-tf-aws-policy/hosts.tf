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

resource "checkpoint_management_host" "mat" {
    name ="mat"
    ipv4_address = "192.168.10.99"
    color = "orange"
}

resource "checkpoint_management_host" "cpobj" {
    color        = "blue"
  
    ipv4_address = "1.2.3.3"
    name         = "cpobj"
    nat_settings = {
        "auto_rule"   = "true"
        "hide_behind" = "gateway"
        "install_on"  = "All"
        "method"      = "hide"
    }
    tags         = []
}