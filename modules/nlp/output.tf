output "nlb_dns" {
 value = aws_lb.NLB_LB.dns_name
}
output "nlb_arn" {
 value = aws_lb.NLB_LB.arn
}
output "target_group_arn" {
 value = aws_lb_target_group.target_group.arn 
 }
output "listener_arn" {
 value = aws_lb_listener.lb_listener.arn
 }
 
