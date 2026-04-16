variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "instance_name" {
  description = "Name of the Compute Engine instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the Compute Engine instance"
  type        = string
  default = "e2-micro"
}

variable "db_ip" {
  description = "Internal IP address of the database instance"
  type        = string
}

variable "db_instance" {
  description = "DB Instance Ressource"
  type = any
}

variable "private_subnet_id" {
  description = "Private Subnet ID for VMs"
  type = string
}