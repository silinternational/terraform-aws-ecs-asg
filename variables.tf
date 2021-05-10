variable "cluster_name" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  default = "t2.micro"
}

variable "user_data" {
  type    = string
  default = "false"
}

variable "root_volume_size" {
  type    = number
  default = 8
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 5
}

variable "health_check_type" {
  type    = string
  default = "EC2"
}

variable "health_check_grace_period" {
  type    = number
  default = 300
}

variable "default_cooldown" {
  type    = number
  default = 30
}

variable "termination_policies" {
  type    = list(string)
  default = ["Default"]
}

variable "protect_from_scale_in" {
  default = false
}

variable "tags" {
  type = list(object({ key = string, value = string, propagate_at_launch = bool }))

  default = [
    {
      key                 = "Created By"
      value               = "Terraform"
      propagate_at_launch = true
    },
  ]
}

variable "scaling_adjustment_up" {
  type    = number
  default = 1
}

variable "scaling_adjustment_down" {
  type    = number
  default = -1
}

variable "scaling_metric_name" {
  type    = string
  default = "CPUReservation"
}

variable "adjustment_type" {
  type    = string
  default = "ChangeInCapacity"
}

variable "policy_cooldown" {
  type    = number
  default = 300
}

variable "evaluation_periods" {
  type    = number
  default = 2
}

variable "alarm_period" {
  type    = number
  default = 120
}

variable "alarm_threshold_up" {
  type    = number
  default = 100
}

variable "alarm_threshold_down" {
  type    = number
  default = 50
}

variable "alarm_actions_enabled" {
  type    = bool
  default = true
}

variable "ssh_key_name" {
  type    = string
  default = ""
}

variable "use_amazon_linux2" {
  type    = bool
  default = true
}

variable "ami_architecture" {
  type    = string
  default = "x86_64"
}
