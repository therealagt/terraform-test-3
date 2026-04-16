# App VM
resource "google_compute_instance" "app_vm" {
  name         = "app-vm"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["app"]

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
    apt-get install -y nginx netcat-openbsd
    DB_IP="${var.db_ip}"
    if nc -z $DB_IP 3306; then
      STATUS="DB reachable"
    else
      STATUS="DB NOT reachable"
    fi
    echo "<h1>App runs</h1><p>$STATUS ($DB_IP:3306)</p>" > /var/www/html/index.html
    systemctl restart nginx
  EOT

  depends_on = [var.db_instance]
}

