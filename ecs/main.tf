resource "aws_ecs_task_definition" "nginx_task_def" {
  family = "WebServer"
  task_role_arn = var.TaskRole
  execution_role_arn = var.TaskExecRole
  container_definitions = jsonencode([
    {
      name      = "webserver-container"
      image     = "nginx"
      cpu       = 128
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
        }
      ]
    }
  ])

/*   volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  } */
}

resource "aws_ecs_service" "my_ecs_service" {
  name            = "TestService"
  cluster         = var.EcsClusterARN
  task_definition = aws_ecs_task_definition.nginx_task_def.arn
  desired_count   = 3
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = var.TgARN
    container_name   = "webserver-container"
    container_port   = 80
  }
/* 
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  } */
}

