variable "zone" {
  description = "GCP zone of the app VM"
  type        = string
}

variable "app_vm_self_link" {
  description = "Self link of the app VM"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}
