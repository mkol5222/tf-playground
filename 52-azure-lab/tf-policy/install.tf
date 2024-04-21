
// CME_ctrl--cpvmss--52-AZURE-LAB-CPVMSS-RG

variable "install" {
  default = false
}

resource "checkpoint_management_install_policy" "azure" {
  count          = var.install ? 1 : 0
  policy_package = "Azure"
  targets        = ["CME_ctrl--cpvmss--52-AZURE-LAB-CPVMSS-RG"]
}