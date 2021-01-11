#AMIの設定
#AMIのデータソースを"amzn2"という名称で作成
data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#ユーザーデータファイルを読み込む設定
data "template_file" "web_shell" {
  template = file("${path.module}/web.sh.tpl")
}

#webサーバ構築
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amzn2.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.auth.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.pub_a.id]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  tags = {
    Name = "khabib-web"
  }
  user_data = base64encode(data.template_file.web_shell.rendered)
}
