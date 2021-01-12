#DB用サブネットグループを作成
resource "aws_db_subnet_group" "db_subgrp" {
  name       = "khabib-subgrp"
  subnet_ids = [aws_subnet.dbsub_a.id, aws_subnet.dbsub_c.id]

  tags = {
    Name = "khabib-db-subnet-group"
  }
}