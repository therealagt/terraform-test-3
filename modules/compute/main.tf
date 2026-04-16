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
    set -e

    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y nginx mariadb-client

    DB_IP="${var.db_ip}"
    DB_NAME="${var.db_name}"
    DB_USER="${var.db_user}"
    DB_PASSWORD="${var.db_password}"
    STATUS="DB NOT reachable"

    for i in $(seq 1 30); do
      if mysql -h "$DB_IP" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "SELECT 1;" >/tmp/db_test.out 2>/tmp/db_test.err; then
        STATUS="DB connection successful"
        break
      fi
      sleep 5
    done

    cat > /var/www/html/index.html <<HTML
    <html>
      <body>
        <h1>App runs</h1>
        <p>$STATUS</p>
        <p>DB: $DB_IP / $DB_NAME</p>
      </body>
    </html>
    HTML

    systemctl enable nginx
    systemctl restart nginx
  EOT
}

