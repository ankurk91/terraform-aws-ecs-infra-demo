# Terraform AWS ECS App

### Requirements

* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) v2.32
* [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) v1.14

### Usage

* Create an IAM user with `AdministratorAccess` permissions and Create new Access key and Secret
* Configure AWS CLI with newly created credentials

```bash
aws configure --profile cosmic
aws sts get-caller-identity --profile cosmic
```

#### Create S3 Backend

Create a `bootstrap/terraform.tfvars` file by coping the `bootstrap/example.tfvars`

```bash
cd bootstrap
cp example.tfvars terraform.tfvars
terraform init
terraform validate
terraform apply
```

This single S3 backend bucket will be used for all environments for this project.

Note: :warning: The `bootstrap` folder saves the state on local disk.

#### Create main infra

```bash
cd ..
terraform init
```

* Create a `terraform.tfvars` file in root folder by coping the `example.tfvars`

```bash
cp example.tfvars terraform.tfvars
```

> [!IMPORTANT]
> Keep the S3 Backend bucket name and region same here

* Deploy main infra for `dev` environment

```bash
terraform workspace new dev
terraform workspace select dev
terraform validate
terraform plan
terraform apply
```

You can repeat the same for other environment like `prod`

```bash
terraform workspace new prod
terraform workspace select prod
terraform validate
terraform plan
terraform apply
```

> [!IMPORTANT]
> Don't use `default` workspace

### DNS update:

This project assumes that you are **NOT** using Route 53 to manage your DNS.

The variable `dns_records_updated` must be set to `false` initially and once the infra is deployed, and
DNS is update manually, you can set this variable to `true` to make ACM verify certificate.

### Resources

* https://developer.hashicorp.com/terraform/tutorials/aws-get-started
