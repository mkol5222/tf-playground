resource "checkpoint_management_publish" "example" {
  count    = var.publish ? 1 : 0
  triggers = ["${timestamp()}"]

  depends_on = [checkpoint_management_host.spoke-a-host, checkpoint_management_host.spoke-b-host]
}
