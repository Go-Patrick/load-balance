resource "aws_lb_target_group" "load" {
  name     = "load-targat"
  port     = "80"
  vpc_id   = aws_vpc.load.id
  protocol = "HTTP"

  health_check {
    path = "/"
  }
}

resource "aws_lb" "load" {
  name               = "load-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_sg.id]
  subnets            = [aws_subnet.lb1.id, aws_subnet.lb2.id]

  tags = {
    Name = "load-lb"
  }
}

resource "aws_lb_listener" "load" {
  load_balancer_arn = aws_lb.load.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load.arn
  }
}

resource "aws_lb_target_group_attachment" "ass1" {
  target_group_arn = aws_lb_target_group.load.arn
  target_id        = aws_instance.vps1.id
}

resource "aws_lb_target_group_attachment" "ass2" {
  target_group_arn = aws_lb_target_group.load.arn
  target_id        = aws_instance.vps2.id
}