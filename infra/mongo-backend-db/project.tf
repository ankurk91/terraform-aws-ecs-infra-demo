resource "mongodbatlas_project" "backend_project" {
  name   = "${var.project_prefix}-backend-project"
  org_id = var.org_id
}

resource "mongodbatlas_maintenance_window" "backend_db_maintenance_window" {
  project_id  = mongodbatlas_project.backend_project.id
  day_of_week = 3
  hour_of_day = 9
}
