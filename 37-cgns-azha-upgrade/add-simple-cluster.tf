locals {
  rendered-command-int = templatefile(
    "./add-simple-cluster.tftpl",
    {
      MAIN_IP       = "10.247.136.6"
      CLUSTER_NAME  = "cpha1"
      VERSION       = "R81.10"
      PUBLIC_VIP    = "20.23.10.92"
      VIP_ETH0_IP   = "10.247.136.6"
      FRONT_NETMASK = "255.255.255.240"
      SIC_KEY       = "WelcomeHome1984"
      NODE1_PUB_PIP = "20.23.10.73"
      NODE1_ETH0_IP = "10.247.136.4"  //module.int_nic["cluster_1_1"].ip_configuration[0].private_ip_address
      NODE1_ETH1_IP = "10.247.136.21" //module.int_nic["cluster_1_2"].ip_configuration[0].private_ip_address
      BACK_NETMASK  = "255.255.255.240"
      NODE2_PUB_PIP = "20.23.12.254"
      NODE2_ETH0_IP = "10.247.136.5"
      NODE2_ETH1_IP = "10.247.136.22"
    }
  )
}

// /tmp/tfout/mgmt-commands-ext.txt
resource "local_file" "mgmt-file-int" {
  content  = local.rendered-command-int
  filename = "/tmp/tfout/mgmt-commands1.txt"
}



output "mgmt-commands-int" {
  value = local.rendered-command-int
}