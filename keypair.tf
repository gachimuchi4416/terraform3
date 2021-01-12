#Webサーバ用の公開鍵設定
data "template_file" "ssh_key" {
  template = file("~/.ssh/id_rsa.pub")
}

resource "aws_key_pair" "auth" {
  key_name   = "id_rsa.pub"
  public_key = data.template_file.ssh_key.rendered
}

#APサーバー用の公開鍵設定
data "template_file" "ssh_key_priv" {
  template = file("~/.ssh/id_rsa_priv.pub")
}

resource "aws_key_pair" "auth_priv" {
  key_name   = "id_rsa_priv.pub"
  public_key = data.template_file.ssh_key_priv.rendered
}