data "aws_availability_zones" "az" {
  state = "available"
}

# Creating vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

# Creating 2 /24 private subnet 
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  count             = var.availability_zones_count
  availability_zone = data.aws_availability_zones.az.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
}


# Creating 2 /24 public subnet 
# Adding availability_zones_count to differ the cidr numnetwork
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = var.availability_zones_count
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.availability_zones_count + count.index)
  map_public_ip_on_launch = true
}

# Create gateway to make public accessible
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}


# == Create gateway for nat

# Elastic IP
resource "aws_eip" "nat" {
  count      = var.availability_zones_count
  depends_on = [aws_internet_gateway.gateway]
  vpc        = true
}

# NAT 
# Element needed to map to each private ip
resource "aws_nat_gateway" "gateway" {
  count         = var.availability_zones_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat.*.id, count.index)
}

# == Routing table

# Public
resource "aws_route" "internet" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

# Private
resource "aws_route_table" "private" {
  count  = var.availability_zones_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
}

# Attaching routing table to the private subnet
resource "aws_route_table_association" "private" {
  count          = var.availability_zones_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
