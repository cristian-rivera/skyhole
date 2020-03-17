variable "name" {
  default = "SkyHole"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.0.0/20"
}

variable "openvpn_subnet_cidr_block" {
  default = "10.0.2.0/24"
}

variable "domain_name_servers" {
  type    = list(string)
  default = ["1.1.1.1", "1.0.0.1"]
}

variable "openvpn_private_ip" {
  default = "10.0.1.0"
}

variable "openvpn_instance_type" {
  default = "t3.micro"
}

variable "openvpn_ami" {
  default = "ami-04b9e92b5572fa0d1"
}

variable "pi-hole_private_ip" {
  default = "10.0.1.1"
}

variable "pi-hole_instance_type" {
  default = "t3.micro"
}

variable "pi-hole_ami" {
  default = "ami-04b9e92b5572fa0d1"
}
