output "cme_cmds" {
    value = <<AAA
autoprov_cfg init AWS -mn CP-Management-gwlb-tf -tn gwlb-configuration -otp WelcomeHome1984 -po Standard -cn cpman -r eu-west-1 -iam -ver R81.20
autoprov_cfg set template -tn gwlb-configuration -ia -ips
AAA
}