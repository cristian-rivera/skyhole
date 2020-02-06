resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = local.tags
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "${var.region}a"
  tags              = local.tags
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}

resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name_servers = var.domain_name_servers
  tags                = local.tags
}

resource "aws_vpc_dhcp_options_association" "dhcp_options_association" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags                   = local.tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_default_route_table.route_table.id
}

resource "aws_default_security_group" "security_group" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_default_network_acl" "network_acl" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id
  subnet_ids             = [aws_subnet.a.id]
  tags                   = local.tags

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
