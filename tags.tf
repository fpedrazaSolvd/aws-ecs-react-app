locals {
  common_tags = {
    DeleteOn    = var.delete_on
    Environment = var.env_name
    Developer   = var.developer
    Provisioner = var.provisioner
    SourceRepo  = var.source_repo
  }
}
