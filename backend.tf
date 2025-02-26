terraform {
  backend "s3" {
    bucket = "expense-tf"
    key    = "observability-tools/state"
    region = "us-east-1"
  }

}