resource "aws_iam_role" "instance_role" {
  name = "${var.name}_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name        = "${var.name}_instance"
    Charge_Code = var.tags[0].charge_code
    Environment = var.tags[0].environment
    OpCo        = var.tags[0].opco
  }
}

resource "aws_iam_role_policy_attachment" "containerservice_role_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "cloudwatchagent_role_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}_instance_profile"
  role = aws_iam_role.instance_role.name
}