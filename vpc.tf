resource "aws_vpc" "dev" {
  cidr_block = "10.42.0.0/16"
  tags = {
      Name = "dev net"
  }

}

resource "aws_subnet" "dev" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.42.10.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "dev 10"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev"
  }
}


resource "aws_default_route_table" "dev" {
  default_route_table_id = aws_vpc.dev.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


}