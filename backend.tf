terraform {
  backend "s3" {
    bucket         = "cloudlogic20-tfstate"
    key            = "terraformdemo.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "s3-state-lock"
  }
}
