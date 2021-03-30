
// ECS cluster

resource "aws_ecs_cluster" "myECSCluster" {
  name = "TestCluster"
}


// Application load balancer for micro services running in ECS
resource "aws_lb" "my_alb" {
  name               = "alb-ecs-test-cluster"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.AlbSg]
  subnets            = [var.public_subnets[0], var.public_subnets[1]]

/*   access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }
 */
  tags = {
    Environment = "production"
  }
}

// TargetGroup

resource "aws_lb_target_group" "my_tg" {
  name     = "TgForNginxService"
  protocol = "HTTP"
  port = 80
  vpc_id   = var.vpcId

  health_check {
    protocol = "HTTP"
    healthy_threshold = 5
    unhealthy_threshold = 3
    timeout = 10
    interval = 30
    matcher = 200
  }
}

// ALB Listner

resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}


// launch Template with instance userdata

resource "aws_launch_template" "my_ec2_launch_template" {
  name = "ECS-LaunchTemplate"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 30
    }
  }
  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }
  disable_api_termination = true
  ebs_optimized = true
  instance_initiated_shutdown_behavior = "terminate"
  monitoring {
    enabled = true
  }
  iam_instance_profile {
      name = var.InstanceProfileRole
}
  image_id = var.image_id
  instance_type = var.ec2_instance_type
  key_name = var.ssh_keypair

  vpc_security_group_ids = [var.InstanceSg]
/*   tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "test"
    }
  } */

  user_data = filebase64("${path.module}/instanceUserData.sh")
}

resource "aws_autoscaling_group" "my-asg-for-ecs" {
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  vpc_zone_identifier = [var.private_subnets[0], var.private_subnets[1]]

  launch_template {
    id      = aws_launch_template.my_ec2_launch_template.id
    version = "$Latest"
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}
