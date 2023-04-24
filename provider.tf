provider "aws" {
  profile = "mongodb-to-documentdb"
  region  = var.region
  default_tags {
    tags = var.default_tags
  }
}