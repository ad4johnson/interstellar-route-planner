resource "aws_lb" "interstellar_alb" {
  name               = "interstellar-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
}


resource "aws_lb_target_group" "interstellar_tg" {
  name        = "interstellar-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id  # Ensure this variable is defined and valid
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
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