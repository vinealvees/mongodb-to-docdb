resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "docdb-cluster-demo-${count.index}"
  cluster_identifier = aws_docdb_cluster.clusterdocdb.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster" "clusterdocdb" {
  cluster_identifier      = "docdb-cluster-demo"
  availability_zones      = [data.aws_instance.this.availability_zone]
  master_username         = "foo"
  master_password         = "barbut8chars"
  skip_final_snapshot     = "true"
  backup_retention_period = 0
  apply_immediately       = true
}