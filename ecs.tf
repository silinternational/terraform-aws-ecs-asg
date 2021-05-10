data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = var.use_amazon_linux2 ? ["amzn2-ami-ecs-hvm-2.0.*-${var.ami_architecture}-ebs"] : ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "random_id" "code" {
  byte_length = 4
}

data "aws_iam_policy_document" "ecsInstanceRole" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecsInstanceRole" {
  name               = "ecsInstanceRole-${random_id.code.hex}"
  assume_role_policy = data.aws_iam_policy_document.ecsInstanceRole.json
}

data "aws_iam_policy_document" "ecsInstancePolicy" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecsInstanceRolePolicy" {
  name   = "ecsInstanceRolePolicy-${random_id.code.hex}"
  role   = aws_iam_role.ecsInstanceRole.id
  policy = data.aws_iam_policy_document.ecsInstancePolicy.json
}

data "aws_iam_policy_document" "ecsServiceRoleAssumeRolePolicy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecsServiceRole" {
  name               = "ecsServiceRole-${random_id.code.hex}"
  assume_role_policy = data.aws_iam_policy_document.ecsServiceRoleAssumeRolePolicy.json
}

data "aws_iam_policy_document" "ecsServiceRolePolicy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecsServiceRolePolicy" {
  name   = "ecsServiceRolePolicy-${random_id.code.hex}"
  role   = aws_iam_role.ecsServiceRole.id
  policy = data.aws_iam_policy_document.ecsServiceRolePolicy.json
}

resource "aws_iam_instance_profile" "ecsInstanceProfile" {
  name = "ecsInstanceProfile-${random_id.code.hex}"
  role = aws_iam_role.ecsInstanceRole.name
}
