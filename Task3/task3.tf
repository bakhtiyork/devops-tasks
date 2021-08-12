provider "aws" {
  region                  = var.AWS_REGION
  shared_credentials_file = "$HOME/.aws/credentials"
}


// NETWORK

resource "aws_vpc" "task3_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"
}

resource "aws_subnet" "task3_subnet" {
  vpc_id                  = aws_vpc.task3_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1a"
}

resource "aws_internet_gateway" "task3_igw" {
  vpc_id = aws_vpc.task3_vpc.id
}

resource "aws_route_table" "task3_public_rt" {
  vpc_id = aws_vpc.task3_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task3_igw.id
  }
}

resource "aws_route_table_association" "task3-rta" {
  subnet_id      = aws_subnet.task3_subnet.id
  route_table_id = aws_route_table.task3_public_rt.id
}


// SECURITY

resource "aws_security_group" "ubuntu_sg" {
  vpc_id = aws_vpc.task3_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "centos_sg" {
  vpc_id = aws_vpc.task3_vpc.id
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.task3_vpc.cidr_block]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.task3_vpc.cidr_block]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.task3_vpc.cidr_block]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.task3_vpc.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.task3_vpc.cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.task3_vpc.cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.task3_vpc.cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.task3_vpc.cidr_block]
  }
}

resource "aws_key_pair" "default_key_pair" {
  key_name   = "default_key_pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}


// AWS INSTANCES

resource "aws_instance" "ubuntu_server" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.task3_subnet.id
  vpc_security_group_ids = [aws_security_group.ubuntu_sg.id]
  key_name               = aws_key_pair.default_key_pair.id


  // Update apt repository, install nginx and create "hello world" page
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
      "echo '<p>Hello World</p>' | sudo tee -a /var/www/html/index.html",
      "echo '<pre>' | sudo tee -a /var/www/html/index.html",
      "cat /etc/os-release | sudo tee -a /var/www/html/index.html",
      "echo '</pre>' | sudo tee -a /var/www/html/index.html",
      "sudo service nginx start"
    ]
  }

  // Install docker
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh"
    ]
  }

  // Install nginx on centos_server
#   provisioner "file" {
#     source = var.PRIVATE_KEY_PATH
#     destination = "~/.ssh/id_rsa"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod 400 ~/.ssh/id_rsa",
#       "curl https://nginx.org/packages/centos/8/x86_64/RPMS/nginx-1.20.1-1.el8.ngx.x86_64.rpm -o nginx.rpm",
#       "scp nginx.rpm centos@${aws_instance.centos_server.private_ip}:/home/centos",
#       "ssh centos@${aws_instance.centos_server.private_ip} -f 'sudo rpm -i nginx.rpm'",
#       "ssh centos@${aws_instance.centos_server.private_ip} -f 'sudo systemctl start nginx'"
#     ]
#   }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${var.PRIVATE_KEY_PATH}")
  }
}

resource "aws_instance" "centos_server" {
  ami                    = "ami-073a8e22592a4a925"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.task3_subnet.id
  vpc_security_group_ids = [aws_security_group.centos_sg.id]
  key_name               = aws_key_pair.default_key_pair.id
}


