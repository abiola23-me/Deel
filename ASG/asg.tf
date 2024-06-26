resource "aws_launch_configuration" "web_lc" {
  name          = "web-lc"
  image_id      = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  user_data     = aws_instance.web_server.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  launch_configuration = aws_launch_configuration.web_lc.name
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.public_subnet.id]
  health_check_type    = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  elb                    = aws_elb.web_elb.id
}
