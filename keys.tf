resource "aws_key_pair" "key_pair" {
  key_name   = local.tags.Name
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.private_key.private_key_pem
  filename          = "${path.module}/private_key.pem"
  file_permission   = "0400"
}

resource "local_file" "public_key" {
  sensitive_content = tls_private_key.private_key.public_key_pem
  filename          = "${path.module}/public_key.pem"
  file_permission   = "0400"
}
