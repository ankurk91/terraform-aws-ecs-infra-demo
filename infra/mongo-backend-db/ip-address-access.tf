locals {
  # Define your office IPs as a list
  office_ips = [

  ]

  # Combine and reverse the IP addresses
  allowed_ip_addresses = reverse(concat(local.office_ips, var.ip_addresses))
  allowed_ip_map = { for idx, ip in local.allowed_ip_addresses : "ip_${idx}" => ip }
}

resource "mongodbatlas_project_ip_access_list" "backend_project_ip_access" {
  project_id = mongodbatlas_project.backend_project.id
  for_each = local.allowed_ip_map
  ip_address = each.value
  comment    = "IP Address for accessing the cluster"
}
