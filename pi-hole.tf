resource "aws_eip" "pi-hole" {
  vpc                       = true
  network_interface         = aws_network_interface.pi-hole.id
  associate_with_private_ip = var.pi-hole_private_ip
  tags                      = merge(local.tags, {Name = "Pi-hole"})
}

resource "aws_network_interface" "pi-hole" {
  subnet_id       = aws_subnet.a.id
  private_ips     = [var.pi-hole_private_ip]
  tags            = merge(local.tags, {Name = "Pi-hole"})
  security_groups = [
    aws_default_security_group.security_group.id,
    aws_security_group.pi-hole.id
  ]
}

resource "aws_security_group" "pi-hole" {
  name        = "Pi-hole"
  description = "Allow all traffic from IP of terraform executor"
  vpc_id      = aws_vpc.vpc.id
  tags        = merge(local.tags, {Name = "Pi-hole"})

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${chomp(data.http.ip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "pi-hole" {
  ami           = var.pi-hole_ami
  instance_type = var.pi-hole_instance_type
  key_name      = aws_key_pair.key_pair.key_name
  tags          = merge(local.tags, {Name = "Pi-hole"})
  volume_tags   = merge(local.tags, {Name = "Pi-hole"})

  root_block_device {
    encrypted   = true
    volume_size = 10
    volume_type = "gp2"
  }

  network_interface {
    network_interface_id = aws_network_interface.pi-hole.id
    device_index         = 0
  }

  provisioner "file" {
    source      = "config/pi-hole"
    destination = "/tmp"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.private_key.private_key_pem
      host        = aws_eip.pi-hole.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/pi-hole/setup",
      "sudo /tmp/pi-hole/setup -i ${var.pi-hole_private_ip} -d ${join(",", var.domain_name_servers)}"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.private_key.private_key_pem
      host        = aws_eip.pi-hole.public_ip
    }
  }
}
