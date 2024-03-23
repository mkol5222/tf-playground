
# module "management" {

#     source = "github.com/mkol5222/CloudGuardIaaS/terraform/aws/management"
    
  
#   // --- VPC Network Configuration ---
#   vpc_id = "vpc-0e1e127a71e05ef1c"
#   subnet_id = aws_subnet.inspcection_vp_cpman_subnet.id
  
#   // --- EC2 Instances Configuration ---
#   management_name = "CP-Management-tf"
#   management_instance_type = "m5.xlarge"
#   key_name = "azureshell"
#   allocate_and_associate_eip = true
#   volume_size = 100
#   volume_encryption = "alias/aws/ebs"
#   enable_instance_connect = false
#   disable_instance_termination = false
#   instance_tags = {
#     key1 = "value1"
#     key2 = "value2"
#   }
  
#   // --- IAM Permissions ---
#   iam_permissions = "Create with read permissions"
#   predefined_role = ""
#   sts_roles = []
  
#   // --- Check Point Settings ---
#   management_version = "R81.20-BYOL"
#   admin_shell = "/bin/bash"
#   # WelcomeHome1984
#   management_password_hash = "$6$ycLB31kh2cbEDSnk$b1ZMkobMX/RUXmDWKDWnr2fPpWaGyMAZHyjg0tFrggUA6ehd8YglKyj3H0hyYCNQrgzXn89TohVj1qW2l3LoI0"
#   management_maintenance_mode_password_hash = "$6$ycLB31kh2cbEDSnk$b1ZMkobMX/RUXmDWKDWnr2fPpWaGyMAZHyjg0tFrggUA6ehd8YglKyj3H0hyYCNQrgzXn89TohVj1qW2l3LoI0" # For R81.10 and below the management_password_hash is used also as maintenance-mode password.
#   // --- Security Management Server Settings ---
#   management_hostname = "mgmt-tf"
#   management_installation_type = "Primary management"
#   SICKey = ""
#   allow_upload_download = "true"
#   gateway_management = "Locally managed"
#   admin_cidr = "0.0.0.0/0"
#   gateway_addresses = "0.0.0.0/0"
#   primary_ntp = ""
#   secondary_ntp = ""
#   management_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
# }