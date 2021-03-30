output "myInstanceSgForECS" {
    value = aws_security_group.my_instance_sg.id
}

output "myAlbIngressSg" {
    value = aws_security_group.my_alb_sg.id
}

output "myEcsTaskSg" {
    value = aws_security_group.my_task_sg.id
}

output "myInstanceRoleForECS" {
    value = aws_iam_role.my_ec2_instance_role.arn
}

output "myInstanceProfileForECS" {
    value = aws_iam_instance_profile.my_ec2_instance_profile.name
}

output "myEcsTaskExecutionRole" {
    value = aws_iam_role.my_ecs_task_execution_role.arn
}

output "myEcsTaskRole" {
    value = aws_iam_role.my_ecs_task_role.arn
}
