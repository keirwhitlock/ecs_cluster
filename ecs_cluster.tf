resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.name

  tags = {
    Charge_Code = var.tags[0].charge_code
    Environment = var.tags[0].environment
    OpCo        = var.tags[0].opco
  }
}