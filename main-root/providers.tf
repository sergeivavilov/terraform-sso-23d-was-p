# Provider
provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "312-main-account-state-bucket"
    key    = "iam-identity-center-23d"
    region = "us-east-2"
  }
}
