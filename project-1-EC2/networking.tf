# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name      = "project-1"
#     ManagedBy = "terraform"
#     project   = "project-1"
#   }
# }

# resource "aws_subnet" "public" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.0.0/24"

#   tags = {
#     Name      = "project-1-public"
#     ManagedBy = "terraform"
#     project   = "project-1"
#   }
# }

# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name      = "project-1-main"
#     ManagedBy = "terraform"
#     project   = "project-1"
#   }
# }

# //Creates a route table associated with the VPC.
# //Defines a route that sends traffic destined for any IP (0.0.0.0/0) through the Internet Gateway.
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }
#   tags = {
#     Name      = "project-1-main"
#     ManagedBy = "terraform"
#     project   = "project-1"
#   }
# }

# //Associates the public subnet with the public route table.
# // This ensures that resources in the subnet can access the Internet.
# resource "aws_route_table_association" "public" {
#   subnet_id      = aws_subnet.public.id
#   route_table_id = aws_route_table.public.id

# }



locals {
  common_tages = {
    Name        = "project-1"
    ManagedBy   = "terraform"
    project     = "project-1"
    cost_center = "1234"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = local.common_tages
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = merge(local.common_tages, {
    Name = "project-1-public"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tages, {
    Name = "project-1-main"
  })
}

//Creates a route table associated with the VPC.
//Defines a route that sends traffic destined for any IP (0.0.0.0/0) through the Internet Gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(local.common_tages, {
    Name = "project-1-main"
  })
}

//Associates the public subnet with the public route table.
// This ensures that resources in the subnet can access the Internet.
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

}