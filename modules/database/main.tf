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
    set -e

    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y mariadb-server
    sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf || true
    systemctl restart mariadb

    until mysqladmin ping --silent; do
      sleep 2
    done

    mysql <<SQL
    CREATE DATABASE IF NOT EXISTS ${var.db_name};
    CREATE USER IF NOT EXISTS '${var.db_user}'@'10.0.2.%' IDENTIFIED BY '${var.db_password}';
    GRANT ALL PRIVILEGES ON ${var.db_name}.* TO '${var.db_user}'@'10.0.2.%';
    FLUSH PRIVILEGES;
    SQL
  EOT
}