output "asg_id" {
  value = aws_autoscaling_group.asg.id
}

output "asg_arn" {
  value = aws_autoscaling_group.asg.arn
}

output "asg_launch_template_id" {
  value = aws_launch_template.lt.id
}

output "ecs_ami_id" {
  value = data.aws_ami.ecs_ami.id
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_instance_profile_id" {
  value = aws_iam_instance_profile.ecsInstanceProfile.id
}

output "ecsInstanceRole_arn" {
  value = aws_iam_role.ecsInstanceRole.arn
}

output "ecsServiceRole_arn" {
  value = aws_iam_role.ecsServiceRole.arn
}
