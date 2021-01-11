#VPCの作成
resource "aws_vpc" "khabib" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "khabib-vpc"
  }
}

#WEBサーバ用Public Subnetの作成

#AZ1aにてWEBサーバ用のサブネットを構築
resource "aws_subnet" "public_1a" {
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
resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.khabib.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "khabib-private-1a"
  }
}

#Elastic IPの構築
resource "aws_eip" "khabib" {
  vpc = true
  tags = {
    Name = "khabib-ngw-pub-a-EIP"
  }
}