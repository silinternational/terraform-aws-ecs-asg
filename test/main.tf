module "simple" {
  source = "../"

  cluster_name       = "cluster"
  security_group_ids = ["sg-01234567"]
  subnet_ids         = ["subnet-01234567"]
}

module "full" {
  source = "../"

  adjustment_type                 = "ChangeInCapacity"
  alarm_actions_enabled           = true
  alarm_period                    = "120"
  alarm_threshold_down            = "50"
  alarm_threshold_up              = "100"
  cluster_name                    = "cluster"
  default_cooldown                = "30"
  ecsInstanceRoleAssumeRolePolicy = "{}"
  ecsInstancerolePolicy           = "{}"
  ecsServiceRoleAssumeRolePolicy  = "{}"
  ecsServiceRolePolicy            = "{}"
  evaluation_periods              = "2"
  health_check_grace_period       = "300"
  health_check_type               = "EC2"
  instance_type                   = "t2.micro"
  max_size                        = "5"
  min_size                        = "1"
  policy_cooldown                 = "300"
  protect_from_scale_in           = false
  scaling_adjustment_down         = "-1"
  scaling_adjustment_up           = "1"
  scaling_metric_name             = "CPUReservation"
  security_group_ids              = ["sg-01234567", "sg-76543210"]
  ssh_key_name                    = "ssh"
  subnet_ids                      = ["subnet-01234567", "subnet-76543210"]
  tags                            = { foo : "bar" }
  termination_policies            = ["Default"]
  use_amazon_linux2               = false
  user_data                       = "false"
}
