#ホストゾーンの作成
resource "aws_route53_zone" "khabib" {
  name = "yui-yasuhiko.work"
}

#Webサーバー用レコード設定
resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.khabib.zone_id
  name    = aws_route53_zone.khabib.name
  type    = "A"
  # ttl     = "300"
  # records = [aws_instance.web.public_ip]
  alias {
    name                   = aws_lb.web.dns_name
    zone_id                = aws_lb.web.zone_id
    evaluate_target_health = true
  }
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

#DNS検証用レコード
# resource "aws_route53_record" "cert_validation" {
#   zone_id = aws_route53_zone.khabib.zone_id
#   name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
#   type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
#   records = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
#   ttl     = 60
# }

resource "aws_route53_record" "cert_validation" {

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.khabib.zone_id
}
