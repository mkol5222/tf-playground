# data "dome9_organizational_unit" "root" {
#   id = "00000000-0000-0000-0000-000000000000"
# }

# 

# resource "dome9_organizational_unit" "demo" {
#   name      = "demo-ou"
#   parent_id = data.dome9_organizational_unit.root.id
# }

resource "dome9_cloudaccount_kubernetes" "test" {
  name  = "cluster-aug22b"
  organizational_unit_id = "00000000-0000-0000-0000-000000000000"
  # runtime_protection {
  #   enabled = false
  # }
  admission_control {
    enabled = true
  }
  image_assurance {
    enabled = true
  }
  threat_intelligence {
    enabled = false
  }
}

output "clusterId" {
  value = dome9_cloudaccount_kubernetes.test.id
}

output "helmcmd" {
    value = "helm install asset-mgmt cloudguard --repo https://raw.githubusercontent.com/CheckPointSW/charts/master/repository/ --set credentials.user=\"${var.D9K8SCLIENT}\" --set credentials.secret=${var.D9K8SSECRET} --set clusterID=${dome9_cloudaccount_kubernetes.test.id} --set addons.flowLogs.enabled=false --set addons.runtimeProtection.enabled=false --set addons.imageScan.enabled=true --set addons.admissionControl.enabled=true --set datacenter=euwe1 --set imageRegistry.user=\"checkpoint+consec_read\" --set imageRegistry.password=V08FPKKJSHP8YJYLE571MMLAHPOSPX1ASFBI4P875L4ZNQWEXUCEU0V4ASWCZVAZ --namespace cp --create-namespace"
}

variable "D9K8SCLIENT" {
  
}

variable "D9K8SSECRET" {
  
}