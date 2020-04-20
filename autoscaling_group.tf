data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["591542846629"]

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "ecs_instance_user_data" {
  template = "${file("${path.module}/scripts/ecs_instance_user_data.tpl")}"
  vars = {
    ecs_cluster_name = var.name
  }
}

resource "aws_launch_template" "ecs_cluster_launch_template" {
  name                                 = "${var.name}_launch_template"
  image_id                             = data.aws_ami.ecs_ami.id
  instance_initiated_shutdown_behavior = "terminate"
  # instance_type                        = "t3.large"
  user_data = base64encode(data.template_file.ecs_instance_user_data.rendered)
  key_name  = "keir.whitlock-laptopKey"
  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = ["${aws_security_group.ecs_cluster_instance_sg.id}"]
    delete_on_termination = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.name}_instance"
      Charge_Code = var.tags[0].charge_code
      Environment = var.tags[0].environment
      OpCo        = var.tags[0].opco
    }
  }

}

resource "aws_autoscaling_group" "ecs_cluster" {
  name                = "${var.name}_asg"
  vpc_zone_identifier = var.subnets
  min_size            = var.min_num_instances
  desired_capacity    = var.desired_num_instances
  max_size            = var.max_num_instances

  mixed_instances_policy {
    instances_distribution {
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 2
      spot_max_price                           = ""
      on_demand_percentage_above_base_capacity = var.ondemand_percentage
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ecs_cluster_launch_template.id
        version            = "$Latest"
      }


      dynamic "override" {
        for_each = var.instance_types_to_use
        content {
          instance_type     = override.value.type
          weighted_capacity = override.value.weight
        }
      }

    }
  }

  tag {
    key                 = "Name"
    value               = "${var.name}_asg"
    propagate_at_launch = false
  }
  tag {
    key                 = "Charge_Code"
    value               = var.tags[0].charge_code
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.tags[0].environment
    propagate_at_launch = true
  }
  tag {
    key                 = "OpCo"
    value               = var.tags[0].opco
    propagate_at_launch = true
  }
}