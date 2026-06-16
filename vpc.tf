################################################################################
# Amazon Virtual Private Cloud (VPC)
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/
  version = "6.6.0"
  name    = "${var.name_prefix}-${var.env_name}"

  cidr = "10.0.0.0/16"

  azs = [ 
    "us-east-2a",
    "us-east-2b",
  ]

  private_subnets = [
    "10.0.0.0/24", #>>> private_subnet_AZ_A
    "10.0.1.0/24", #>>> private_subnet_AZ_B
  ]

  private_subnet_tags = {
    subnet_type = "private",
  }

  public_subnets = [
    "10.0.2.0/24", #>>> public_subnet_AZ_A
    "10.0.3.0/24", #>>> public_subnet_AZ_B
  ]

  public_subnet_tags = {  
    subnet_type = "public",
  }

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true
}
