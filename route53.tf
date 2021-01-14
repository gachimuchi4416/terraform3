#ホストゾーンの作成
resource "aws_route53_zone" "khabib" {
  name = "yui-yasuhiko.work"
}

#Webサーバー用レコード設定
resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.khabib.zone_id
  name    = aws_route53_zone.khabib.name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web.public_ip]
}

#Internal ホストゾーンの作成
resource "aws_route53_zone" "in" {
  name = "internal"

  vpc {
    vpc_id = aws_vpc.khabib.id
  }

  tags = {
    Name = "Internal DNS Zone"
  }
}

#内部APサーバー用のレコード構築
resource "aws_route53_record" "ap_in" {
  zone_id = aws_route53_zone.in.zone_id
  name    = "ap"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ap.private_ip]
}

#内部RDSの書き込み用レコード構築
resource "aws_route53_record" "aurora_clstr_in" {
  zone_id = aws_route53_zone.in.zone_id
  name    = "rds"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster.aurora_clstr.endpoint]
}

#内部RDSの読み込み用レコード構築
resource "aws_route53_record" "aurora_clstr_ro_in" {
  zone_id = aws_route53_zone.in.zone_id
  name    = "rds-ro"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster.aurora_clstr.reader_endpoint]
}