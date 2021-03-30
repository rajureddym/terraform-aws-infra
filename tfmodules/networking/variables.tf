variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
  description = "AWS VPC CIDR Block Range"
}

variable "public_subnet_cidr_block_01" {
  type = string
  default = "10.0.1.0/24"
  description = "AWS VPC Subnet CIDR Block Range"
}

variable "public_subnet_cidr_block_02" {
  type = string
  default = "10.0.2.0/24"
  description = "AWS VPC Subnet CIDR Block Range"
}
variable "private_subnet_cidr_block_01" {
  type = string
  default = "10.0.3.0/24"
  description = "AWS VPC Subnet CIDR Block Range"
}
variable "private_subnet_cidr_block_02" {
  type = string
  default = "10.0.4.0/24"
  description = "AWS VPC Subnet CIDR Block Range"
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-east-2a","us-east-2b"]
}