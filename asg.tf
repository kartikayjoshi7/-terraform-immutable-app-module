resource "aws_autoscaling_group" "asg" {
  name     = "${var.COMPONENT}-${var.ENV}"
  desired_capacity = var.INSTANCE_COUNT
  max_size = var.MAX_SIZE
  min_size = var.MIN_SIZE

  launch_template {
    id      = aws_launch_template.lauch-template.id
    version = "$Latest"
  }

  #  health_check_grace_period = 300
  #  health_check_type         = "ELB"
  #  desired_capacity          = 4
  #  force_delete              = true
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS

  tag {
    key                 = "Name"
    value               = "${var.COMPONENT}-${var.APP_VERSION}"
    propagate_at_launch = true
  }


  tag {
    key                 = "Monitor"
    value               = yes
    propagate_at_launch = true
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

}

resource "aws_autoscaling_policy" "cpu-tracking-policy" {
  name            = "whenCPULoadIncrease"
  policy_type     = "TargetTrackingScaling"
  adjustment_type = "ChangeInCapacity"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
