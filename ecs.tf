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