# These outputs display information to the terminal
output "account_id" {
  description = "Account which terraform was run on"
  value       = data.aws_caller_identity.current.account_id
}

output "common_tags" {
  description = "tags which should be applied to all taggable objects"
  value       = local.common_tags
}

output "org" {
  description = "string to prepend to resource name - optional"
  value       = var.org
}

output "name_prefix" {
  description = "string to prepend to all resource names"
  value       = var.name_prefix
}

output "env_name" {
  description = "string to append to all resource names"
  value       = var.env_name
}

output "region" {
  description = "region being used"
  value       = var.region
}

################################################################################
# s3-bucket-terraform-state
################################################################################

# Comment block below after the s3 bucket for remote state is created

# output "terraform_state_bucket" {
#   description = "s3 bucket to store terraform state"
#   value       = module.terraform_state.bucket
# }

# output "terraform_state_dynamodb_table" {
#   description = "dynamodb table to control terraform locking"
#   value       = module.terraform_state.dynamodb_table
# }

# output "terraform_state_kms_key_arn" {
#   description = "kms key to use for encrytption when storing/reading terraform state configuration"
#   value       = module.terraform_state.kms_default_key_arn
# }

# output "terraform_state_config_s3_key" {
#   description = "key to use for terraform state key configuration - this is the s3 object key where the config will be stored"
#   value       = "${var.org}-${var.name_prefix}-${var.env_name}-remote-state-backend.tfstate"
# }

################################################################################