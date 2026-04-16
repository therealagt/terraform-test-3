module "network" {
  source = "../../modules/network"
  
  region = var.region
  zone   = var.zone
}

module "database" {
  source = "../../modules/database"
  
  machine_type       = var.machine_type
  zone               = var.zone
  private_subnet_id  = module.network.private_subnet_id
  db_name            = var.db_name
  db_user            = var.db_user
  db_password        = var.db_password
}

module "compute" {
  source = "../../modules/compute"
  
  machine_type       = var.machine_type
  zone               = var.zone
  private_subnet_id  = module.network.private_subnet_id
  db_ip              = module.database.db_ip
  db_name            = var.db_name
  db_user            = var.db_user
  db_password        = var.db_password

  depends_on = [module.database]
}

module "loadbalancer" {
  source = "../../modules/loadbalancer"

  zone             = var.zone
  app_vm_self_link = module.compute.app_vm_self_link
  vpc_name         = module.network.vpc_name
}