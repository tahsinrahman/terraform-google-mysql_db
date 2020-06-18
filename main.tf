terraform {
  required_version = ">= 0.12.24" # see https://releases.hashicorp.com/terraform/
  experiments      = [variable_validation]
}

provider "google" {
  version = ">= 3.13.0" # see https://github.com/terraform-providers/terraform-provider-google/releases
}

locals {
  master_instance_name_suffix  = format("%s-%s", var.name_master_instance, var.name_suffix)
  failover_replica_name_suffix = format("-%s", var.name_failover_replica)
  read_replica_name_suffix     = format("-%s-", var.name_read_replica)
  master_authorized_networks = [
    for authorized_network in var.authorized_networks_master_instance : {
      name  = authorized_network.display_name
      value = authorized_network.cidr_block
    }
  ]
  read_replica_authorized_networks = [
    for authorized_network in var.authorized_networks_read_replica : {
      name  = authorized_network.display_name
      value = authorized_network.cidr_block
    }
  ]
  failover_replica_authorized_networks = [
    for authorized_network in var.authorized_networks_failover_replica : {
      name  = authorized_network.display_name
      value = authorized_network.cidr_block
    }
  ]
}

data "google_client_config" "google_client" {}

resource "google_project_service" "cloudsql_api" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

module "google_mysql_db" {
  source            = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version           = "3.2.0"
  module_depends_on = concat(var.module_depends_on, [google_project_service.cloudsql_api.id])
  project_id        = data.google_client_config.google_client.project
  name              = format("mysql-%s", local.master_instance_name_suffix)
  db_name           = var.db_name
  database_version  = var.db_version
  db_collation      = var.db_collation
  db_charset        = var.db_charset
  region            = data.google_client_config.google_client.region
  zone              = "a"
  availability_type = var.highly_available ? "REGIONAL" : null
  tier              = var.instance_size_master
  create_timeout    = var.db_timeout
  update_timeout    = var.db_timeout
  delete_timeout    = var.db_timeout
  user_name         = var.user_name

  ip_configuration = {
    authorized_networks = local.master_authorized_networks
    ipv4_enabled        = var.public_access_master_instance
    private_network     = var.private_network
    require_ssl         = null
  }

  # backup settings
  backup_configuration = {
    enabled            = var.backup_enabled
    binary_log_enabled = var.pit_recovery_enabled
    start_time         = "00:05"
  }

  # read replica settings
  read_replica_size        = var.read_replica_count
  read_replica_name_suffix = local.read_replica_name_suffix
  read_replica_zones       = "b,c"
  read_replica_tier        = var.instance_size_replica
  read_replica_configuration = {
    connect_retry_interval    = null
    dump_file_path            = null
    ca_certificate            = null
    client_certificate        = null
    client_key                = null
    failover_target           = false
    master_heartbeat_period   = null
    password                  = null
    ssl_cipher                = null
    username                  = null
    verify_server_certificate = null
  }
  read_replica_ip_configuration = {
    authorized_networks = local.read_replica_authorized_networks
    ipv4_enabled        = var.public_access_read_replica
    private_network     = var.private_network
    require_ssl         = null
  }

  # failover replica settings
  failover_replica             = var.failover_enabled
  failover_replica_name_suffix = local.failover_replica_name_suffix
  failover_replica_zone        = "c"
  failover_replica_tier        = var.instance_size_failover
  failover_replica_configuration = {
    connect_retry_interval    = null
    dump_file_path            = null
    ca_certificate            = null
    client_certificate        = null
    client_key                = null
    failover_target           = true
    master_heartbeat_period   = null
    password                  = null
    ssl_cipher                = null
    username                  = null
    verify_server_certificate = null
  }
  failover_replica_ip_configuration = {
    authorized_networks = local.failover_replica_authorized_networks
    ipv4_enabled        = var.public_access_failover_replica
    private_network     = var.private_network
    require_ssl         = null
  }
}
