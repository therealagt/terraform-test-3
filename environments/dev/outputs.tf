output "lb_ip" {
  value = module.loadbalancer.lb_ip
}

output "app_vm_ip" {
  value = module.compute.app_vm_ip
}

output "db_ip" {
  value = module.database.db_ip
}
