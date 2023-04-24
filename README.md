
# Migrating from MongoDB to Amazon DocumentDB

This project has intention to create all resources needed for Migrating from [MongoDB to Amazon DocumentDB Tutorial](https://docs.aws.amazon.com/dms/latest/sbs/chap-mongodb2documentdb.html). All resources use the VPC Default and no settings need to be done if you use it.



## Deploy

To deploy all resources, make a repository clone, navigate to root directory and run terraform.

```bash
  git clone https://github.com/vinealvees/mongodb-to-docdb.git
  cd mongodb-to-docdb
  terraform init
  terraform plan -out=plan.tf
  terraform apply
```


## Documentation

It will be created the following resources:
- 1x Database Migration Replication Instance
- 2x Database Migration Endpoint
- 1x Database Migration Certificate
- 1x DocumentDB Cluster Instance
- 1x DocumentDB Cluster
- 1x IAM Instace Profile
- 1x EC2 Instance
- 4x IAM Role

## Reference

 - [Migrating from MongoDB to Amazon DocumentDB](https://docs.aws.amazon.com/dms/latest/sbs/chap-mongodb2documentdb.html)
 - [Amazon DocumentDB Index Tool](https://github.com/awslabs/amazon-documentdb-tools)
 - [Terraform Provider AWS Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)


## Authors

- [@vinealvees](https://github.com/vinealvees)