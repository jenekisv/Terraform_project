#----------------------------------------------------------
# My Terraform
#
# Build WebServer during Bootstrap
#
# Made by Evgenii Sviridov 2024
#----------------------------------------------------------

provider "aws" {
  region = var.region
}

resource "aws_default_vpc" "default" {}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id

  tags = {
    Name  = "Web Server IP"
    Owner = "Evgenii Sviridov"
  }
}

#----------------------------------------------------------

resource "aws_instance" "my_webserver" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = var.instance_type
  key_name               = "evgen-key-n_virginia"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Evgenii",
    l_name = "Sviridov",
    names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha", "Lena", "Katya"]
  })

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  } # chtobi rabotali IMDSv1 "/meta-data/local-ipv4"

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Evgenii Sviridov"
  }

  lifecycle {
    create_before_destroy = true
  }

}

#----------------------------------------------------------

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First SecurityGroup"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  } # otpravka tolko echo zaprosa

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
    Owner = "Evgenii Sviridov"
  }
}
