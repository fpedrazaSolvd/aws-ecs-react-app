<!-- BEGIN_TF_DOCS -->

# AWS ECS cluster

This repository is meant to hold all of the relevant stateful Terraform code
for for the AWS ECS cluster.

## Pre-commit

Project maintainers can take advantage of `pre-commit` to automate various
tasks before commiting changes to repositories. To easily recreate the checks
that GitHub Actions performs when a pull request is created or updated,
you can create an alias for your shell.

Create a folder to cache tflint plugins, avoid repeated API calls, and get faster tflint executions:

```bash
mkdir -p .tflint.d/
```

Add the cache folder to `.gitignore`
```bash
.tflint.d/
```

Create a Personal Access Token in GitHub (Settings > Developer Settings > Personal Access Token), with Read access to metadata permission.

Set the token as a variable in the shell: 

```bash
read -s '?GitHub token: ' GITHUB_TOKEN; echo; export GITHUB_TOKEN
```

Set the alias for pre-commit-run:

```bash
alias pre-commit-run='docker run --rm \
  -v "$(pwd):/lint" \
  -v "$HOME/.tflint.d:/root/.tflint.d" \
  -w /lint \
  -e GITHUB_TOKEN \
  --entrypoint /bin/sh \
  ghcr.io/antonbabenko/pre-commit-terraform:latest \
  -c "tflint --init && pre-commit run -a"'
```
Run the alias:

```bash
pre-commit-run
```

## Deployment

To quickly initialize the current Terraform configuration and create or update
the associated infrastructure, try the following commands:

> **_NOTE:_**  You must have a valid AWS session token for the following
commands to complete successfully.

### Development (dev)

Prepare your working directory for other Terraform commands:
```bash
terraform init -backend-config=./init-tfvars/dev.tfvars
```
Show changes required by the current configuration:
```bash
terraform plan -var-file ./apply-tfvars/dev.tfvars
```
Create or update infrastructure:
```bash
terraform apply -var-file ./apply-tfvars/dev.tfvars
```
 
## Documentation

This repo is self documenting via Terraform Docs, please see the note at the
bottom.

The `.config/.terraform-docs.yml` file auto generates the `README.md` file

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.14.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.40.0 |

## Resources

| Name | Type |
|------|------|

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terraform_state"></a> [terraform\_state](#module\_terraform\_state) | git::https://github.com/fapd777/terraform-module-state-s3-bucket.git | v26.5.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delete_on"></a> [delete\_on](#input\_delete\_on) | Date to delete the resources | `string` | n/a | yes |
| <a name="input_developer"></a> [developer](#input\_developer) | Developer name | `string` | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | The name of the current environment (e.g. dev, stg, prd). | `string` | n/a | yes |
| <a name="input_logging_bucket"></a> [logging\_bucket](#input\_logging\_bucket) | Bucket used for centralized logging. | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | String to use as prefix on object names. | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | Organization name | `string` | n/a | yes |
| <a name="input_provisioner"></a> [provisioner](#input\_provisioner) | Infrastructure provisioning method | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region to target. | `string` | n/a | yes |
| <a name="input_source_repo"></a> [source\_repo](#input\_source\_repo) | URL of repository where this configuration is maintained. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | Account which terraform was run on |
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | tags which should be applied to all taggable objects |
| <a name="output_env_name"></a> [env\_name](#output\_env\_name) | string to append to all resource names |
| <a name="output_name_prefix"></a> [name\_prefix](#output\_name\_prefix) | string to prepend to all resource names |
| <a name="output_org"></a> [org](#output\_org) | string to prepend to resource name - optional |
| <a name="output_region"></a> [region](#output\_region) | region being used |
| <a name="output_terraform_state_bucket"></a> [terraform\_state\_bucket](#output\_terraform\_state\_bucket) | s3 bucket to store terraform state |
| <a name="output_terraform_state_config_s3_key"></a> [terraform\_state\_config\_s3\_key](#output\_terraform\_state\_config\_s3\_key) | key to use for terraform state key configuration - this is the s3 object key where the config will be stored |
| <a name="output_terraform_state_dynamodb_table"></a> [terraform\_state\_dynamodb\_table](#output\_terraform\_state\_dynamodb\_table) | dynamodb table to control terraform locking |
| <a name="output_terraform_state_kms_key_arn"></a> [terraform\_state\_kms\_key\_arn](#output\_terraform\_state\_kms\_key\_arn) | kms key to use for encrytption when storing/reading terraform state configuration |

---

> **_NOTE:_**  Manual changes to the README will be overwritten when the
documentation is updated. To update the documentation, run:
```bash
terraform-docs --config .config/.terraform-docs.yml .
```
<!-- END_TF_DOCS -->