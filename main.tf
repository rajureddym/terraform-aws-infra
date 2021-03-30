//provider configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

provider "aws" {
  profile = var.aws-credentials-profile
  region  = var.aws-region
}

module "network" {
 source = "./modules/networking"
}

module "security" {
 source = "./modules/security"
 vpcId = module.network.myVpcId
 vpcCidr = module.network.myVpcCidr
}

module "compute" {
    source = "./modules/computing"
    private_subnets = [module.network.myPriavteSubnetId-01, module.network.myPriavteSubnetId-02]
    public_subnets = [module.network.myPublicSubnetId-01, module.network.myPublicSubnetId-02]
    vpcId = module.network.myVpcId
    vpcCidr = module.network.myVpcCidr
    InstanceSg = module.security.myInstanceSgForECS
    InstanceProfileRole = module.security.myInstanceProfileForECS
    AlbSg  = module.security.myAlbIngressSg
    ssh_keypair = var.ssh_keypair
}

module "ecs" {
    source = "./modules/ecs"
    private_subnets = [module.network.myPriavteSubnetId-01, module.network.myPriavteSubnetId-02]
    TaskSg = module.security.myEcsTaskSg 
    TaskExecRole = module.security.myEcsTaskExecutionRole
    TaskRole = module.security.myEcsTaskRole
    AlbARN = module.compute.myAlb
    TgARN = module.compute.myTg
    EcsClusterARN = module.compute.myEcsCluster
}