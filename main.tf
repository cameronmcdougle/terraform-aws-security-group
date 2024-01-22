# data sources
data "aws_vpc" "default" {
  id = var.vpc_id
  # look up cidr block from vpc id
}

data "aws_region" "current" {}

# s3 endpoint
data "aws_prefix_list" "s3" {
  name = "com.amazonaws.${data.aws_region.current.name}.s3"
}

resource "aws_security_group" "this" {
  name = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}

# inbound rules
resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  count             = var.create_http_ingress_rule ? 1 : 0
  security_group_id = aws_security_group.this.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_443" {
  count             = var.create_https_ingress_rule ? 1 : 0
  security_group_id = aws_security_group.this.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

## s3 endpoint
resource "aws_security_group_rule" "s3_gateway_ingress" {
  count             = var.create_s3_endpoint_ingress_rule ? 1 : 0
  description       = "S3 Gateway ingress"
  type              = "ingress"
  security_group_id = aws_security_group.this.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_prefix_list.s3.id]
}

# outbound rules
resource "aws_vpc_security_group_egress_rule" "http" {
  count             = var.create_http_egress_rule ? 1 : 0
  security_group_id = aws_security_group.this.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "https" {
  count             = var.create_https_egress_rule ? 1 : 0
  security_group_id = aws_security_group.this.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

## s3 endpoint
resource "aws_security_group_rule" "s3_gateway_egress" {
  count             = var.create_s3_endpoint_egress_rule ? 1 : 0
  description       = "S3 Gateway Egress"
  type              = "egress"
  security_group_id = aws_security_group.this.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_prefix_list.s3.id]
}
