resource "aws_lb" "interstellar_alb" {
  name               = "interstellar-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-07c8c59647ab697f1"]
  subnets            = ["subnet-00e47d9c39cfaeaf3", "subnet-04b4390b7d6e34c60"]
}

resource "aws_lb_target_group" "interstellar_tg" {
  name        = "interstellar-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0c58473b204cc096c"
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