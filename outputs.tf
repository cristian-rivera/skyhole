output "pi-hole_private_ip" {
  value = aws_eip.pi-hole.private_ip
}

output "pi-hole_public_ip" {
  value = aws_eip.pi-hole.public_ip
}

output "openvpn_private_ip" {
  value = aws_eip.openvpn.private_ip
}

output "openvpn_public_ip" {
  value = aws_eip.openvpn.public_ip
}
