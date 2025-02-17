resource "aws_lb" "interstellar_alb" {
  name               = "interstellar-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0a6fa3f01fa5e9ad0"]
  subnets            = ["subnet-05e7dc0bf11f2bc06", "subnet-08595d9184fb831c5"]
}

resource "aws_lb_target_group" "interstellar_tg" {
  name        = "interstellar-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0ebf59b186a59f2bc"
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.interstellar_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.interstellar_tg.arn
  }
}