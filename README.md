# terraform-aws-infra
## usage of terraform

1. clone the repository `git clone https://github.com/rajureddym/terraform-aws-infra.git`
2. initialize the terraform in the directory, run `terraform init`
3. run `terraform plan` to see the resources that creating (updates/deletes for subsequent changes) in AWS
4. run `terraform apply` to deploy the changes to infrastructure 

---
**Note:** When you run `terraform plan/apply` command, It will ask you for Input for variables such as [AWS Region](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html#Concepts.RegionsAndAvailabilityZones.Availability) and [AWS Credential Profile](https://docs.aws.amazon.com/sdk-for-php/v3/developer-guide/guide_credentials_profiles.html) to use for authentication & creation of AWS resources

---
The given terraform template consists of 4 modules (networking, security, computing and ecs) that creates all necessary AWS resources to run docker workloads in AWS Elastic Container Service (ECS)