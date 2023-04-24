terraform {
  backend "s3" {
    bucket         = "terraform-backend-config-xpto"
    key            = "infra-resources"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    profile        = "backend"
  }
}
