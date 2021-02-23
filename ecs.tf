/*
 * Determine most recent ECS optimized AMI
 */
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = var.use_amazon_linux2 ? ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"] : ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

/*
 * Create ECS cluster
 */
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

/*
 * Create ECS IAM Instance Role and Policy
 */
resource "random_id" "code" {
  byte_length = 4
}

resource "aws_iam_role" "ecsInstanceRole" {
  name               = "ecsInstanceRole-${random_id.code.hex}"
  assume_role_policy = var.ecsInstanceRoleAssumeRolePolicy
}

resource "aws_iam_role_policy" "ecsInstanceRolePolicy" {
  name   = "ecsInstanceRolePolicy-${random_id.code.hex}"
  role   = aws_iam_role.ecsInstanceRole.id
  policy = var.ecsInstancerolePolicy
}

resource "aws_iam_role_policy" "ecsInstanceRoleSsmPolicy" {
  count  = var.use_ssm ? 1 : 0
  role   = aws_iam_role.ecsInstanceRole.id
  policy = data.template_file.ecs_instance_role_ssm_policy.rendered
}

data "template_file" "ecs_instance_role_ssm_policy" {
  template = file("${path.module}/ecsInstanceroleSsmPolicy.json")

  vars = {
    app_name = var.app_name
    app_env  = var.app_env
    region   = var.region
  }
}

/*
 * Create ECS IAM Service Role and Policy
 */
resource "aws_iam_role" "ecsServiceRole" {
  name               = "ecsServiceRole-${random_id.code.hex}"
  assume_role_policy = var.ecsServiceRoleAssumeRolePolicy
}

resource "aws_iam_role_policy" "ecsServiceRolePolicy" {
  name   = "ecsServiceRolePolicy-${random_id.code.hex}"
  role   = aws_iam_role.ecsServiceRole.id
  policy = var.ecsServiceRolePolicy
}

resource "aws_iam_instance_profile" "ecsInstanceProfile" {
  name = "ecsInstanceProfile-${random_id.code.hex}"
  role = aws_iam_role.ecsInstanceRole.name
}

/*
 * ECS related variables
 */

// Required:
variable "cluster_name" {}

variable "app_name" {}

variable "app_env" {}

variable "region" {}

// Optional:

variable "use_amazon_linux2" {
  default     = false
  description = "Use Amazon Linux 2 instead of Amazon Linux"
}

variable "ecsInstanceRoleAssumeRolePolicy" {
  type = string

  default = <<EOF
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
}

variable "ecsInstancerolePolicy" {
  type = string

  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
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
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

variable "use_ssm" {
  default     = false
  description = "Allow access via AWS Systems Manager"
}

variable "ecsServiceRoleAssumeRolePolicy" {
  type = string

  default = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

variable "ecsServiceRolePolicy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
