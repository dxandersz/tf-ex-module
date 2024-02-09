# resources related to the AWS security group

# security group for EC2 cluster
resource "aws_security_group" "instance" {
    name="${var.cluster_name}-instance"
}

resource "aws_security_group_rule" "allow_http_cluster" {
    type = "ingress"    
    security_group_id = aws_security_group.instance.id     

    from_port = local.http_port
    to_port = local.http_port
    protocol = local.tcp_protocol
    cidr_blocks = local.all_ips
}

# security group for load balancer
resource "aws_security_group" "alb" {
    name = "${var.cluster_name}-alb"
}

resource "aws_security_group_rule" "allow_http_inbound" {
    # Allow inbound HTTP requests
    type = "ingress"
    security_group_id = aws_security_group.alb.id 

    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
    # Allow all outbound requests
    type = "egress" 
    security_group_id = aws_security_group.alb.id

    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.all_ips
}