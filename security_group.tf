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

#RDS用セキュリティグループの作成
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.khabib.id
  tags = {
    Name = "rds-sg"
  }
}

#出ていく通信の設定
resource "aws_security_group_rule" "egress_rds_sg" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}

#3306を受け入れる設定
resource "aws_security_group_rule" "ingress_rds_3306" {
  type              = "ingress"
  from_port         = "3306"
  to_port           = "3306"
  protocol          = "tcp"
  cidr_blocks       = ["10.0.2.0/24"]
  security_group_id = aws_security_group.rds_sg.id
}


#ALBがHTTPSを受け付けるセキュリティグループの作成
resource "aws_security_group" "alb_web" {
  name   = "alb_web"
  vpc_id = aws_vpc.khabib.id
  tags = {
    Name = "khabib-alb-web"
  }
}

#出ていく通信の設定
resource "aws_security_group_rule" "egress_alb_web" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_web.id
}

#HTTPSを受け入れる設定
resource "aws_security_group_rule" "ingress_alb_web_443" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_web.id
}

#ALB-WEBサーバー間の通信を許可するSGの構築
resource "aws_security_group" "share" {
  name   = "share"
  vpc_id = aws_vpc.khabib.id
  tags = {
    Name = "khabib-share"
  }
}

#出ていく通信の設定
resource "aws_security_group_rule" "egress_share" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.share.id
}

#HTTPSを受け入れる設定
resource "aws_security_group_rule" "ingress_share_self" {
  type              = "ingress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.share.id
}