################################################################################
# Application Load Balancer Security Group
################################################################################

resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-${var.env_name}-alb"
  description = "Access to ALB"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.name_prefix}-${var.env_name}-alb"
  }
}

resource "aws_security_group_rule" "alb_allow_all_egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.alb.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outgoing traffic from the ALB."
}

resource "aws_security_group_rule" "alb_allow_inbound_http" {
  from_port         = 80
  protocol          = "TCP"
  security_group_id = aws_security_group.alb.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Internet access to ALB"
}

#################################################################################################
# This section describes the Load Balancer resources: ALB, ALB target group, ALB listener
#################################################################################################

#Defining the Application Load Balancer
resource "aws_alb" "ecs" {
  name               = "${var.name_prefix}-${var.env_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups    = [aws_security_group.alb.id]
}

#Defining the target group and a health check on the application
resource "aws_lb_target_group" "ecs-http" {
  name        = "${var.name_prefix}-${var.env_name}-tg"
  port        = 3000 # container port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    port                = "3000"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 300
  }
}

#Defines an HTTP Listener for the ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.ecs.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-http.arn
  }
}