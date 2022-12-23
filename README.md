# Terraform - Auto Scaling ECS NGINX Cluster

## Description

Terraform is an infrastructure as code (IaC) that can help you to manage your infrastructure with configuration files and cli

## How does it work

Terraform has many provider that can connect the terraform itself and the service such as AWS, Azure, GCP, k8s and many more.

It can manage your infrastructure such as

1. Making new contiainers
2. Adding policies to service
3. Creating auto scaling
4. And many more!

## Requirements

1. [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. Prefered provider (In this case AWS)

## How to run

1. Install terraform by following the guide in the [requirements](#requirements)
2. Clone the repository using `git clone https://github.com/IloveNooodles/Terraform-ECS-Nginx-Cluster` or download the zip version
3. Generate `Access key` and `Secret key` and if you don't understand what it is please refer to [this](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/) document
4. Create `terraform.tvars` by copying `terraform.tfvars.example`
5. Fill your prefered-region (default: us-east-1)
6. Fill the `aws_access_key_id` and `aws_secret_access_key` that you got from the aws website
7. Run `terraform init` to create `terraform.lock` file
8. Run `terraform plan` to create the build plan
9. If you satisfied with the current plan you can run `terraform apply` to create your configuration in your provider
10. If `apply` is successful then console will output the url you can visit!

```
...SNIP...
Apply complete! Resources: 28 added, 0 changed, 0 destroyed.

Outputs:

alb_hostname = "nginx-load-balancer-559564577.us-east-1.elb.amazonaws.com"
```

11. Run `terraform destroy` to destory all the instance.

Note: all variables defined in the `variables.tf` and it can be changed or provide it with the same name in .tfvars if you're not satisfied with the configuration

## References

1. [AWS User policy](https://docs.aws.amazon.com/polly/latest/dg/setting-up.html)
2. [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
3. [Terraform configuration](https://developer.hashicorp.com/terraform/language)
4. [Auto scaling policies](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-simple-step.html)
5. [Amazon Cloudwatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)
