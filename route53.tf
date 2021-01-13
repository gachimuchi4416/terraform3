#ホストゾーンの作成
resource "aws_route53_zone" "yui-yasuhiko.work" {
  name = "yui-yasuhiko.work"
}

#Webサーバー用レコード設定
resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.yui-yasuhiko.work.zone_id
  name    = aws_route53_zone.yui-yasuhiko.work.name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web.public_ip]
}