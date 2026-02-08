resource "aws_lb" "NLB_LB" {
  name = var.name
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = var.subnets
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.name}-tg"
  port        = var.lb_target_port
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    protocol = "TCP"
    port     = "traffic-port"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.NLB_LB.arn 
  port              = var.lb_listener_port
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
