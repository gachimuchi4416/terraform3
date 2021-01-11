#Webサーバ用の公開鍵設定
data "template_file" "ssh_key" {
  template = file("~/.ssh/id_rsa.pub")
}

resource "aws_key_pair" "auth" {
  key_name   = "id_rsa.pub"
  public_key = data.template_file.ssh_key.rendered
}