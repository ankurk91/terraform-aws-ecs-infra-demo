locals {
  # Default values for when workspace is not explicitly defined in the map
  default_cluster_config = {
    instance_size                  = "M0"
    node_count                     = 0
    backup_enabled                 = false
    provider_name                  = "TENANT"
    termination_protection_enabled = false
    mongo_db_major_version         = null
    version_release_system         = null
    backing_provider_name          = "AWS"
  }

  cluster_configs = {
    dev     = local.default_cluster_config
    staging = local.default_cluster_config
    prod = {
      instance_size                  = "M10"
      node_count                     = 3
      backup_enabled                 = true
      provider_name                  = "AWS"
      termination_protection_enabled = true
      mongo_db_major_version         = "8.0"
      version_release_system         = "LTS"
      backing_provider_name          = null
    }
  }

  current_cluster_config = lookup(local.cluster_configs, terraform.workspace, local.default_cluster_config)

  instance_size                  = local.current_cluster_config.instance_size
  node_count                     = local.current_cluster_config.node_count
  backup_enabled                 = local.current_cluster_config.backup_enabled
  provider_name                  = local.current_cluster_config.provider_name
  termination_protection_enabled = local.current_cluster_config.termination_protection_enabled
  mongo_db_major_version         = local.current_cluster_config.mongo_db_major_version
  version_release_system         = local.current_cluster_config.version_release_system
  backing_provider_name          = local.current_cluster_config.backing_provider_name
}

# Notes: You need to configure cluster autoscaling manually via Web Interface
resource "mongodbatlas_advanced_cluster" "backend_db_cluster" {
  project_id   = mongodbatlas_project.backend_project.id
  name         = "${var.project_prefix}-backend-cluster"
  cluster_type = "REPLICASET"
  # tenant cluster does not allow to specify db versions
  mongo_db_major_version         = local.mongo_db_major_version
  version_release_system         = local.version_release_system
  backup_enabled                 = local.backup_enabled
  termination_protection_enabled = local.termination_protection_enabled

  replication_specs {
    region_configs {
      priority      = 7
      provider_name = local.provider_name
      # backing_provider_name is required with TENANT cluster
      backing_provider_name = local.backing_provider_name
      region_name           = var.region

      electable_specs {
        instance_size = local.instance_size
        node_count    = local.node_count
      }

      dynamic "auto_scaling" {
        for_each = terraform.workspace == "prod" ? [1] : []

        content {
          disk_gb_enabled            = true
          compute_enabled            = true
          compute_scale_down_enabled = true
          compute_min_instance_size  = local.instance_size
          compute_max_instance_size  = "M30"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # allow autoscaling
      replication_specs[0].region_configs[0].electable_specs[0].instance_size,
    ]
  }

}

output "connection_strings" {
  value = mongodbatlas_advanced_cluster.backend_db_cluster.connection_strings[0].standard_srv
}
