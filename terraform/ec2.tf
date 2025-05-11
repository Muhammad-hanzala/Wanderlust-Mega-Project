resource "aws_key_pair" "deployer" {
  key_name   = "terra-key"
  public_key = file("/c/Users/Osama/Desktop/Wander-lust-Mega-Project/Wanderlust-Mega-Project/terraform/terra-key.pub")
}

resource "aws_default_vpc" "default" {

  }

resource "aws_security_group" "allow_user_to_connect" {
  name        = "allow TLS"
  description = "Allow user to connect"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    description = "port 22 allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 
  }

  egress {
    description = " allow all outgoing traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 

  }

  ingress {
    description = "port 80 allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 

  }

  ingress {
    description = "port 443 allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 
  }
  ingress {
    description = "port 465 allow"
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 
  }
  ingress {
    description = "port 6379 allow"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 
  }
  ingress {
    description = "port 25 allow"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 
  }
  ingress {
    description = "port 6443 allow"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 
  }
  ingress {
    description = "port 30000-32767 allow"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 
  }
  ingress {
    description = "port 3000-10000 allow"
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []    
    prefix_list_ids  = []    
    security_groups  = []    
    self             = false 
  }
  
  tags = {
    Name = "mysecurity"
  }
}

resource "aws_instance" "testinstance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.allow_user_to_connect.name]
  tags = {
    Name = "Automate"
  }
  root_block_device {
    volume_size = 30 
    volume_type = "gp3"
  }
}
