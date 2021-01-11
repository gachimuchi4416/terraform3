#WEBサーバがSSHとHTTPを受けるセキュリティグループの作成
resource "aws_security_group" "pub_a" {
  name   = "khabib_pub_a"
  vpc_id = aws_vpc.khabib.id
  tags = {
    Name = "khabib-pub-a"
  }
}

#出ていく通信の設定
resource "aws_security_group_rule" "egress_pub_a" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pub_a.id
}

#SSH/SFTPを受け入れる設定
resource "aws_security_group_rule" "ingress_pub_a_22" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pub_a.id
}

#HTTPを受け入れる設定
resource "aws_security_group_rule" "ingress_pub_a_80" {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pub_a.id
}

#APサーバのセキュリティグループの作成
resource "aws_security_group" "priv_a" {
  name   = "khabib_priv_a"
  vpc_id = aws_vpc.khabib.id
  tags = {
    Name = "khabib-priv-a"
  }
}

#出ていく通信の設定
resource "aws_security_group_rule" "egress_priv_a" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.priv_a.id
}

#SSHを受け入れる設定
resource "aws_security_group_rule" "ingress_priv_a_22" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.0/24"]
  security_group_id = aws_security_group.priv_a.id
}