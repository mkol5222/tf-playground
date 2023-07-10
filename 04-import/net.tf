
# terraform plan -out plan.out -generate-config-out=imported-nets.tf
import {
    to = checkpoint_management_network.users
    id = "users"
}