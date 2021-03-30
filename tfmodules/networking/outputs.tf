output "myVpcId" {
    value = aws_vpc.my_vpc.id
}

output "myVpcCidr" {
    value = aws_vpc.my_vpc.cidr_block
}

output "myPriavteSubnetId-01" {
    value = aws_subnet.my_private_subnet_01.id
}
output "myPriavteSubnetId-02" {
    value = aws_subnet.my_private_subnet_02.id
}
output "myPublicSubnetId-01" {
    value = aws_subnet.my_public_subnet_01.id
}
output "myPublicSubnetId-02" {
    value = aws_subnet.my_public_subnet_02.id
}

