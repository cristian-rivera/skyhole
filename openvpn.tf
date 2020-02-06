resource "aws_eip" "openvpn" {
  vpc                       = true
  network_interface         = aws_network_interface.openvpn.id
  associate_with_private_ip = var.openvpn_private_ip
  tags                      = merge(local.tags, {Name = "OpenVPN"})
}

resource "aws_network_interface" "openvpn" {
  subnet_id       = aws_subnet.a.id
  private_ips     = [var.openvpn_private_ip]
  tags            = merge(local.tags, {Name = "OpenVPN"})
  security_groups = [
    aws_default_security_group.security_group.id,
    aws_security_group.openvpn.id
  ]
}

resource "aws_security_group" "openvpn" {
  name        = "OpenVPN"
  description = "Allow all traffic from IP of terraform executor"
  vpc_id      = aws_vpc.vpc.id
  tags        = merge(local.tags, {Name = "OpenVPN"})

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${chomp(data.http.ip.body)}/32"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "openvpn" {
  ami           = var.openvpn_ami
  instance_type = var.openvpn_instance_type
  key_name      = aws_key_pair.key_pair.key_name
  tags          = merge(local.tags, {Name = "OpenVPN"})
  volume_tags   = merge(local.tags, {Name = "OpenVPN"})

  root_block_device {
    encrypted   = true
    volume_size = 10
    volume_type = "gp2"
  }

  network_interface {
    network_interface_id = aws_network_interface.openvpn.id
    device_index         = 0
  }

  provisioner "file" {
    source      = "config/openvpn"
    destination = "/tmp"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.private_key.private_key_pem
      host        = aws_eip.openvpn.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/openvpn/setup",
      "sudo /tmp/openvpn/setup -n ${var.name} -o ${aws_eip.openvpn.public_ip} -p ${var.pi-hole_private_ip} -s ${var.openvpn_subnet_cidr_block}"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.private_key.private_key_pem
      host        = aws_eip.openvpn.public_ip
    }
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${local_file.private_key.filename} ubuntu@${aws_eip.openvpn.public_ip}:/tmp/openvpn/client.ovpn ."
  }
}
