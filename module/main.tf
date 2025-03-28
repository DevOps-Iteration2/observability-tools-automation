resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  tags   = {
    Name = var.tool_name
  }

  lifecycle {
    ignore_changes = [
    ami,
    ]
  }
}

resource "aws_route53_record" "record" {
  name    = var.tool_name
  type    = "A"
  zone_id = var.zone_id
  records = [aws_instance.instance.public_ip]
  ttl     = 30
}

resource "aws_route53_record" "record-internal" {
  name    = "${var.tool_name}-internal"
  type    = "A"
  zone_id = var.zone_id
  records = [aws_instance.instance.private_ip]
  ttl     = 30
}

resource "aws_iam_role" "role" {
  name = "${var.tool_name}-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.tool_name}-role"
  }
}

resource "aws_iam_role_policy" "policy" {
  name = "${var.tool_name}-role-policy"
  role   = aws_iam_role.role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = concat(var.dummy_policy,var.policy_resource_list)
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.tool_name}-profile"
  role = aws_iam_role.role.name
}
