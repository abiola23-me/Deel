

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.5.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public_b" {
  vpc_id      = aws_vpc.main.id
  cidr_block   = "10.0.3.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-2a"
  cidr_block = "10.0.6.0/24"
}
resource "aws_subnet" "private_b" {
  vpc_id    = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.public.id
}
resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_a" {
  ami           = "ami-07d7e3e669718ab45"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_a.id
  security_groups = [aws_security_group.instance.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker pull 730335366177.dkr.ecr.us-east-2.amazonaws.com/abiola:latest
              docker run -d -p 5000:5000 <your-docker-repo>/reverse-ip-app
              EOF
  tags = {
    "Name" = "abiola"
     Environment = "dev"
  }
}



resource "aws_instance" "app_b" {
  ami                    = "ami-07d7e3e669718ab45"  # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_b.id
  vpc_security_group_ids = [aws_security_group.instance.id]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker pull 730335366177.dkr.ecr.us-east-2.amazonaws.com/abiola:latest
              docker run -d -p 5000:5000 <your-docker-repo>/reverse-ip-app
              EOF


  tags = {
    "Name" = "abiola"
     Environment = "dev"
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "app"
  image_id      = "ami-07d7e3e669718ab45"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.instance.id]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_db_instance" "db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  db_name                 = "mydb"
  username             = "abiola"
  password             = "manchester"
  parameter_group_name = "default.postgres16"
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.instance.id]
  db_subnet_group_name = aws_db_subnet_group.main.name

  tags = {
    Name = "mydb-instance"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "main"
  }
}




































