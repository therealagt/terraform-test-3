resource "google_compute_instance_group" "app_group" {
  name      = "app-instance-group"
  zone      = var.zone
  instances = [var.app_vm_self_link]

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_health_check" "app_hc" {
  name = "app-health-check"

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

resource "google_compute_backend_service" "app_backend" {
  name                  = "app-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.app_hc.self_link]

  backend {
    group = google_compute_instance_group.app_group.self_link
  }
}

resource "google_compute_url_map" "app_url_map" {
  name            = "app-url-map"
  default_service = google_compute_backend_service.app_backend.self_link
}

resource "google_compute_target_http_proxy" "app_http_proxy" {
  name    = "app-http-proxy"
  url_map = google_compute_url_map.app_url_map.self_link
}

resource "google_compute_global_address" "app_lb_ip" {
  name = "app-lb-ip"
}

resource "google_compute_global_forwarding_rule" "app_http_rule" {
  name                  = "app-http-forwarding-rule"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.app_http_proxy.self_link
  ip_address            = google_compute_global_address.app_lb_ip.address
}
