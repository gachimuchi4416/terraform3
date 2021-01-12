#DB用サブネットグループを作成
resource "aws_db_subnet_group" "db_subgrp" {
  name       = "khabib-subgrp"
  subnet_ids = [aws_subnet.dbsub_a.id, aws_subnet.dbsub_c.id]

  tags = {
    Name = "khabib-db-subnet-group"
  }
}

#RDSクラスター用のパラメーターグループを構築
resource "aws_rds_cluster_parameter_group" "sb_clstr_pmtgrp" {
  name        = "khabib-cluster-pg"
  family      = "aurora-mysql5.7"
  description = "RDS default cluster parameter group"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  parameter {
    name         = "time_zone"
    value        = "Asia/Tokyo"
    apply_method = "immediate"
  }
}

#DBインスタンス用のパラメーターグループを作成
resource "aws_db_parameter_group" "db_pmtgrp" {
  name        = "khabib-db-pg"
  family      = "aurora-mysql5.7"
  description = "RDS default Instance parameter group"
}