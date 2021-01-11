#VPCの作成
resource "aws_vpc" "khabib" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "khabib-vpc"
  }
}

#WEBサーバ用Public Subnetの作成

#AZ1aにてWEBサーバ用のサブネットを構築
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.khabib.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "khabib-public-1a"
  }
}

#APサーバ用 Private Subnet

#AZ1aにてAPサーバ用のサブネットを構築
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.khabib.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "khabib-private-1a"
  }
}

#Elastic IPの構築
resource "aws_eip" "ngw_eip_a" {
  vpc = true
  tags = {
    Name = "khabib-ngw-pub-a-EIP"
  }
}

#IGWの作成
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.khabib.id
  tags = {
    Name = "khabib-igw"
  }
}

#NATゲートウェイの構築
resource "aws_nat_gateway" "ngw_pub_a" {
  allocation_id = aws_eip.ngw_eip_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "khabib-ngw"
  }
}

#パブリックサブネット用のルートテーブルを作成
resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.khabib.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "khabib-route-tb-pub-a"
  }
}

#パブリックサブネットとルートテーブルの紐付け
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}


#プライベート用のルートテーブルを作成
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.khabib.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_pub_a.id
  }
  tags = {
    Name = "khabib-route-tb-priv-a"
  }
}

#プライベートサブネットとルートテーブルの紐付け
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}