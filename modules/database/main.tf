# DB VM
resource "google_compute_instance" "db_vm" {
  name         = "db-vm"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["db"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = var.private_subnet_id
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y mariadb-server
    sed -i 's/^bind-address.*/bind-address=0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
    systemctl restart mariadb
  EOT
}