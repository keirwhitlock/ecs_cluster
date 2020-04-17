resource "aws_security_group" "ecs_cluster_instance_sg" {
  name   = "${var.name}_instance_sg"
  vpc_id = var.vpc_id
  tags = {
    Name        = "${var.name}_instance"
    Charge_Code = var.tags[0].charge_code
    Environment = var.tags[0].environment
    OpCo        = var.tags[0].opco
  }
}

resource "aws_security_group_rule" "allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_cluster_instance_sg.id
}

resource "aws_security_group_rule" "allow_all_ssh_in" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = aws_security_group.ecs_cluster_instance_sg.id
}