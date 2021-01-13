#DB用サブネットグループを作成
resource "aws_db_subnet_group" "db_subgrp" {
  name       = "khabib-subgrp"
  subnet_ids = [aws_subnet.dbsub_a.id, aws_subnet.dbsub_c.id]

  tags = {
    Name = "khabib-db-subnet-group"
  }
}

#RDSクラスター用のパラメーターグループを構築
resource "aws_rds_cluster_parameter_group" "db_clstr_pmtgrp" {
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

#RDSクラスターの構築
resource "aws_rds_cluster" "aurora_clstr" {
  cluster_identifier              = "aurora-cluster"
  database_name                   = "mydb"
  master_username                 = "admin"
  master_password                 = "1234Admin5678"
  port                            = 3306
  apply_immediately               = false
  skip_final_snapshot             = true
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.07.2"
  vpc_security_group_ids          = [aws_security_group.rds_sg.id]
  db_subnet_group_name            = aws_db_subnet_group.db_subgrp.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_clstr_pmtgrp.name

  tags = {
    Name = "aurora-cluster"
  }
}

#RDSインスタンスの作成
resource "aws_rds_cluster_instance" "aurora_instance" {
  count                   = 2
  identifier              = "aurora-cluster-${count.index}"
  cluster_identifier      = aws_rds_cluster.aurora_clstr.id
  instance_class          = "db.t2.small"
  apply_immediately       = false
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.2"
  db_subnet_group_name    = aws_db_subnet_group.db_subgrp.name
  db_parameter_group_name = aws_db_parameter_group.db_pmtgrp.name

  tags = {
    Name = "aurora-instance"
  }
}

output "rds-endpoint" {
  value = aws_rds_cluster.aurora_clstr.endpoint
}

output "rds-endpoint-ro" {
  value = aws_rds_cluster.aurora_clstr.reader_endpoint
}