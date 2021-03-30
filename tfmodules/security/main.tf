/*
** Network Security **
*/

// SecurityGroup for EC2 Instances

resource "aws_security_group" "my_instance_sg" {
  name        = "Instance-SG"
  description = "Allow inbound traffic within VPC"
  vpc_id      = var.vpcId

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpcCidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// SecurityGroup for Application Load balancer

resource "aws_security_group" "my_alb_sg" {
  name        = "AppLB-SG"
  description = "Allow inbound traffic from open world"
  vpc_id      = var.vpcId

  ingress {
    description = "HTTP from open world"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


// SecurityGroups for ECS tasks that uses awsvpc network mode

resource "aws_security_group" "my_task_sg" {
  name        = "Task-SG"
  description = "Allow inbound traffic from ALB"
  vpc_id      = var.vpcId

  ingress {
    description = "HTTP from ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
//    cidr_blocks = [var.vpcCidr]
    security_groups = [aws_security_group.my_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
** IAM Security**
*/

// InstanceRole for EC2 Instances

resource "aws_iam_role" "my_ec2_instance_role" {
  name                = "MyEc2InstanceRoleForECS"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"]
}

//InstanceProfile
 
resource "aws_iam_instance_profile" "my_ec2_instance_profile" {
  name = "MyEc2InstanceProfile"
  role = aws_iam_role.my_ec2_instance_role.name
}

// ECS Task Execution Role, credntials to create & prepare container to run in AWS

resource "aws_iam_role" "my_ecs_task_execution_role" {
  name                = "MyECSTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

// ECS Task Role, credentails for application to make AWS API to other services

resource "aws_iam_role" "my_ecs_task_role" {
  name                = "MyECSTaskRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}