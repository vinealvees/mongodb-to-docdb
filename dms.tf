# Create a new replication instance
resource "aws_dms_replication_instance" "this" {
  allocated_storage = 20
  availability_zone          = aws_instance.this.availability_zone
  multi_az                   = false
  publicly_accessible        = true
  replication_instance_class = "dms.t2.micro"
  replication_instance_id    = "test-dms-replication-instance-tf"
  tags = {
    Name        = "ri_mongodb2docdb"
    Description = "MongoDB to Amazon DocumentDB replication instance"
  }
  depends_on = [
    aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role,
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]
}

resource "aws_dms_endpoint" "source" {
  database_name = "zips-db"
  endpoint_id   = "mongodb-source"
  endpoint_type = "source"
  engine_name   = "mongodb"
  port          = 27017
  server_name   = aws_instance.this.public_dns
  ssl_mode      = "none"
  mongodb_settings {
    auth_type = "no"
  }

  tags = {
    Name = "endpoint_mongodb2docdb"
  }
}

# Create a new certificate
resource "aws_dms_certificate" "dms_certificate" {
  certificate_id  = "dms-certificate-test"
  certificate_pem = file("./files/rds-combined-ca-bundle.pem")

  tags = {
    Name = "dms_certificate-test"
  }

}

resource "aws_dms_endpoint" "target" {
  certificate_arn = aws_dms_certificate.dms_certificate.certificate_arn
  database_name   = "zips-db"
  endpoint_id     = "docdb-target"
  endpoint_type   = "target"
  engine_name     = "docdb"
  port            = 27017
  server_name     = aws_docdb_cluster.clusterdocdb.endpoint
  ssl_mode        = "verify-full"
  username        = aws_docdb_cluster.clusterdocdb.master_username
  password        = aws_docdb_cluster.clusterdocdb.master_password
  mongodb_settings {
    auth_type = "no"
  }
  tags = {
    Name = "endpoint_mongodb2docdb"
  }
}
