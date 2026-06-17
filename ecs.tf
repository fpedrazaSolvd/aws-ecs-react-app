################################################################################
# Amazon Elastic Container Service (ECS) Security Group
################################################################################

resource "aws_security_group" "ecs" {
  name        = "${var.name_prefix}-${var.env_name}-ecs"
  description = "Access to ECS cluster"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.name_prefix}-${var.env_name}-ecs"
  }
}

resource "aws_security_group_rule" "allow_all_egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ecs.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outgoing traffic from the server."
}

resource "aws_security_group_rule" "allow_inbound_react" {
  from_port         = 3000
  protocol          = "TCP"
  security_group_id = aws_security_group.ecs.id
  to_port           = 3000
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Internet access"
}

resource "aws_security_group_rule" "allow_inbound_http" {
  from_port         = 80
  protocol          = "TCP"
  security_group_id = aws_security_group.ecs.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Internet access"
}

################################################################################
# IAM Role for ECS Task Execution
################################################################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name_prefix}-${var.env_name}-ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

################################################################################
# Amazon Elastic Container Service (ECS) Cluster
################################################################################

resource "aws_ecs_cluster" "react_app" {
  name = "${var.name_prefix}-${var.env_name}-react-app"
}

resource "aws_ecs_task_definition" "container_web" {
  family                   = "container-web"
  cpu                      = "512"  # .5 vCPU = 512 CPU units
  memory                   = "1024" # 1 GB memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "container-web"
      image = "docker.io/fapd777/react-app:1.0.3"
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
          name          = "containerweb-3000-tcp"
          appProtocol   = "http"
        }
      ]
      essential        = true
      environment      = []
      logConfiguration = null
    }
  ])
}

resource "aws_ecs_service" "react_app_service" {
  name            = "react-app-service"
  cluster         = aws_ecs_cluster.react_app.id
  task_definition = "${aws_ecs_task_definition.container_web.family}:${aws_ecs_task_definition.container_web.revision}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-http.arn
    container_name   = "container-web"
    container_port   = 3000
  }
}