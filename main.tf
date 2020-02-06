provider "aws" {
  profile = "default"
  region  = var.region
}

locals {
  tags = {
    Name = var.name
    "Application ID" = var.name
  }
}

data "http" "ip" {
  url = "https://ifconfig.co/ip"
}
