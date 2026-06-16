################################################################################
# Miscellaneous variables
################################################################################

variable "delete_on" {
  description = "Date to delete the resources"
  type        = string
}

variable "developer" {
  description = "Developer name"
  type        = string
}

variable "env_name" {
  description = "The name of the current environment (e.g. dev, stg, prd)."
  type        = string
}

variable "logging_bucket" {
  description = "Bucket used for centralized logging."
  type        = string
}

variable "name_prefix" {
  description = "String to use as prefix on object names."
  type        = string
}

variable "org" {
  description = "Organization name"
  type        = string
}

variable "provisioner" {
  description = "Infrastructure provisioning method"
  type        = string
}

variable "region" {
  description = "The AWS Region to target."
  type        = string
}

variable "source_repo" {
  description = "URL of repository where this configuration is maintained."
  type        = string
}