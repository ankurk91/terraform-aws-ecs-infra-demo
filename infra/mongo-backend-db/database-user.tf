resource "mongodbatlas_database_user" "backend_db_user" {
  username = "${var.project_prefix}-backend-db-user"
  password           = var.db_user_password
  project_id         = mongodbatlas_project.backend_project.id
  auth_database_name = "admin"

  roles {
    role_name = "readWrite"
    # The database name and collection name need not to be exist in the cluster before creating the user.
    database_name = "${var.project_prefix}-backend-db"
  }

  labels {
    key   = "Name"
    value = "${var.project_prefix}-backend-db"
  }

  scopes {
    name = mongodbatlas_advanced_cluster.backend_db_cluster.name
    type = "CLUSTER"
  }

  lifecycle {
    ignore_changes = [password]
  }
}
