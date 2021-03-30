output "myAlb" {
    value = aws_lb.my_alb.arn
}

output "myAlbDNS" {
    value = aws_lb.my_alb.dns_name
}

output "myTg" {
    value = aws_lb_target_group.my_tg.arn
}

output "myASG" {
    value = aws_autoscaling_group.my-asg-for-ecs.arn
}

output "myEcsCluster" {
    value = aws_ecs_cluster.myECSCluster.arn
}