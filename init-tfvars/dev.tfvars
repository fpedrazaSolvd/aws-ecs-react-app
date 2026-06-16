# These variables are called when running the following command:
# terraform init -backend-config=./init-tfvars/dev.tfvars
bucket         = "aws-ecs-poc-remote-state-backend-us-east-2"
key            = "aws-ecs-poc-dev-remote-state-backend.tfstate"
dynamodb_table = "aws-ecs-poc-remote-state-backend-us-east-2"
kms_key_id     = "arn:aws:kms:us-east-2:381511845811:key/0106de87-2f66-4d45-a814-938b0e7b4ef2"