resource "aws_lb" "alb" {
  depends_on = [
    aws_security_group.web_traffic,
    aws_subnet.public_az1,
    aws_subnet.public_az2,
    aws_subnet.public_az3
  ]

  name               = "mikes-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_traffic.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]

  tags = {
    Name      = "mikes-alb"
    CreatedBy = "Mike"
  }
}

resource "aws_lb_listener" "alb" {
  depends_on = [aws_lb.alb]

  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}
