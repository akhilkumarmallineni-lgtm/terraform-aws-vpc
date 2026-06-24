locals {
  common_tags = {
    project     = var.project_name
    environment = var.environment
    terraform   = "true"
    common_name = local.common_name
  }
  common_name = "${var.project_name}-${var.environment}"
  az_names = slice(data.aws_availability_zones.available.names, 0, 2) # here 2 is exlcusive
}