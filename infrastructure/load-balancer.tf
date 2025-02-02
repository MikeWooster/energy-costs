# ---------------------------------------------------------------------------------------------------------------------
# Load Balancing
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb" "alb" {
  depends_on = [
    aws_security_group.public,
    data.aws_subnet_ids.public
  ]

  name               = "${local.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-alb"
  })
}

resource "aws_lb_target_group" "main" {
  depends_on = [aws_vpc.main]

  name        = "${local.prefix}-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled  = true
    interval = 30
    path     = "/health"
    port     = "traffic-port"
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-target-group"
  })
}

resource "aws_lb_listener" "alb" {
  depends_on = [aws_lb.alb, aws_lb_target_group.main]

  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
