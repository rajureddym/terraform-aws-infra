variable "vpcId" {
  type = string
}

variable "vpcCidr" {
  type = string
}

variable "private_subnets" {
  type        = list
  description = "Subnets available"
}

variable "public_subnets" {
  type        = list
  description = "Subnets available"
}

variable "InstanceSg" {
  type = string
}
variable "AlbSg" {
  type = string
}

variable "InstanceProfileRole" {
  type = string
}

variable "ec2_instance_type" {
 type = string
 description = "InstanceType that you want to launch"
 default = "t3.small"

}

variable "ssh_keypair" {
    type = string 
    description = "Enter SSH keypair name"
}

variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  default = "ami-0ecb1ece84d43215d"
}

