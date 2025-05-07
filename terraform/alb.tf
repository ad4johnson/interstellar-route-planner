# =============================
# Generate Unique Target Group Suffix
# =============================
resource "random_id" "suffix" {
  byte_length = 4

  keepers = {
    alb_version = aws_lb.interstellar_alb.id
  }
}

# =============================
# Application Load Balancer (ALB)
# =============================
resource "aws_lb" "interstellar_alb" {
  name               = "interstellar-alb"
  load_balancer_type = "application"

  # Updated to use only 2 subnets explicitly (best practice for ALB + Free Tier OK)
  subnets = [
    aws_subnet.public[0].id, # us-east-1a (example AZ)
    aws_subnet.public[1].id  # us-east-1b (example AZ)
  ]

  security_groups = [aws_security_group.interstellar_sg.id]

  tags = {
    Environment = "production"
    Project     = "interstellar"
  }
}

# =============================
# Target Group for ECS Service
# =============================
resource "aws_lb_target_group" "interstellar_tg" {
  name        = "interstellar-tg-${random_id.suffix.hex}"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = "production"
    Project     = "interstellar"
  }
}

# =============================
# Listener for HTTP Port
# =============================
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.interstellar_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.interstellar_tg.arn
  }

  depends_on = [aws_lb_target_group.interstellar_tg]

  tags = {
    Environment = "production"
    Project     = "interstellar"
  }
}