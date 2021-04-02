**Terraform Basics**

* Key features:
    - IaC
    - Declarative
    - Pluggable
    - DevOps first
        - eliminate configuration drift
        - change automation, deploy complex change sets with minimal human interactions
    - cloud-agnostic & can work with multiple provides simultaneously(OpenStack, CloudFlare) 

**`LifeCycle:`**

 - Init: `terraform init` -> initialize the working directory
 - Write: Author infrastructure as code. Write required tf template to create/update resources
 - PLAN: `terraform plan` -> Preview changes before applying, generates action plan includes all actions to be taken i.e. which resources to be created/updated/modified, to move from real/current state of the infrastructure to the desired state
 - APPLY: `terraform apply`-> Provision reproducible infrastructure i.e.deploy changes to current infrastructure to meet the desired state
 - Destroy: `terraform destroy` -> deletes created infra

**`Terraform core:`**

- Takes two sources as Input
    - tf file (defined Infra config file)
    - tf state file
- compare the current state (from state file) with desired state (from given updated tf file), generates plan with resources what needs to updated or deleted or created

**`Terraform Components:`**

`Providers:`

- Terraform configurations must declare which providers they require so that Terraform can install and use them. 
- Every resource type is implemented by a provider; without providers, Terraform can't manage any kind of infrastructure.

    - IaaS
        - AWS
        - Azure
        - IBM
    - PaaS
        - CloudFoundry
    - SaaS
        - CloudFlare


`Modules:`
- Modules are containers for multiple resources that are used together. A module consists of a collection of `.tf` and/or `.tf.json` files kept together in a directory
- Modules are the main way to package and reuse resource configurations with Terraform
    - `Root Module:` Every Terraform configuration has at least one module, known as its root module, which consists of the resources defined in the .tf files in the main working directory
    - `Child Module:` A Terraform module (usually the root module of a configuration) can call other modules to include their resources into the configuration. A module that has been called by another module is often referred to as a child module.
        - Child modules can be called multiple times within the same configuration, and multiple configurations can use the same child module.

`State:`
- Terraform must store state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

- This state is stored by default in a local file named "terraform.tfstate", but it can also be stored remotely, which works better in a team environment.

- Terraform uses this local state to create plans and make changes to your infrastructure. Prior to any operation, Terraform does a refresh to update the state with the real infrastructure.

- The primary purpose of Terraform state is to store bindings between objects in a remote system and resource instances declared in your configuration. When Terraform creates a remote object in response to a change of configuration, it will record the identity of that remote object against a particular resource instance, and then potentially update or delete that object in response to future configuration changes.

`Variables:` 
- Input variables serve as parameters for a Terraform module, allowing aspects of the module to be customized without altering the module's own source code, and allowing modules to be shared between different configurations

`Outputs:`
- Output values are like the return values of a Terraform module, and have several uses:
    - A child module can use outputs to expose a subset of its resource attributes to a parent module.
    - A root module can use outputs to print certain values in the CLI output after running terraform apply.


-----

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