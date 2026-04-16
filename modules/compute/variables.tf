variable "zone" {
  description = "GCP zone"
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

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "private_subnet_id" {
  description = "Private Subnet ID for VMs"
  type = string
}