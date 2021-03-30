provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

module "network" {
 source = "./networking"
}

module "security" {
 source = "./security"
 vpcId = module.network.myVpcId
 vpcCidr = module.network.myVpcCidr
}

module "compute" {
    source = "./computing"
    private_subnets = [module.network.myPriavteSubnetId-01, module.network.myPriavteSubnetId-02]
    public_subnets = [module.network.myPublicSubnetId-01, module.network.myPublicSubnetId-02]
    vpcId = module.network.myVpcId
    vpcCidr = module.network.myVpcCidr
    InstanceSg = module.security.myInstanceSgForECS
    InstanceProfileRole = module.security.myInstanceProfileForECS
    AlbSg  = module.security.myAlbIngressSg

}

module "ecs" {
    source = "./ecs"
    private_subnets = [module.network.myPriavteSubnetId-01, module.network.myPriavteSubnetId-02]
    TaskSg = module.security.myEcsTaskSg 
    TaskExecRole = module.security.myEcsTaskExecutionRole
    TaskRole = module.security.myEcsTaskRole
    AlbARN = module.compute.myAlb
    TgARN = module.compute.myTg
    EcsClusterARN = module.compute.myEcsCluster
}