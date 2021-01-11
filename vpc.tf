#VPCの作成
resource "aws_vpc" "khabib" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "khabib-vpc"
  }
}