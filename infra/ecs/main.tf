module "backend-service" {
  source              = "./backend-service"
  project_prefix      = var.project_prefix
  aws_account_id      = var.aws_account_id
  aws_region          = var.aws_region
  ecs_cluster_id      = aws_ecs_cluster.ecs_cluster.id
  ecs_cluster_name    = aws_ecs_cluster.ecs_cluster.name
  private_subnets_ids = var.private_subnets_ids
  vpc_id              = var.vpc_id
  alb_arn_suffix      = aws_lb.main_alb.arn_suffix
  alb_listener_arn    = aws_lb_listener.main_alb_listener.arn
  app_domain          = var.backend_app_domain
  ecs_services_alarm_topic_arn = aws_sns_topic.ecs_services_alarm_topic.arn
  s3_suffix_domain = var.s3_suffix_domain
}

