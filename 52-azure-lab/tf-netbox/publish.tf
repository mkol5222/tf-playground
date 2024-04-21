variable "publish" {
  type        = bool
  default     = false
  description = "Set to true to publish changes"
}

resource "checkpoint_management_publish" "example" {
  count    = var.publish ? 1 : 0
  triggers = ["${timestamp()}"]

}