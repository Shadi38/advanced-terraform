resource "aws_instance" "web" {
  //we found ami from "https://cloud-images.ubuntu.com/locator/ec2/" according to the region
  ami                         = "ami-09a2a0f7d2db8baca"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_http_traffic.id]
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
  tags = merge(local.common_tages, {
    Name = "project-1-ec2"
  })
  lifecycle {
    create_before_destroy = true
    ignore_changes = [ tags ] // we use this to prevent Terraform undoing some changes that where done externally
                              // for example somebody in counsole or some outomation changed the tage name and we 
                              // don't want that changes happen after that we use terraform apply in our terraform configeration  
  }
}

resource "aws_security_group" "public_http_traffic" {
  description = "security group allowing traffic on ports 443 and 80"
  name        = "public_http_traffic"
  vpc_id      = aws_vpc.main.id
  tags = merge(local.common_tages, {
    Name = "project-1-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
}