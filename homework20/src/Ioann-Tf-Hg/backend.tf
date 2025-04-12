terraform {
  backend "s3" {
    bucket  = "terraform-state-danit-devops-7"
    key     = "ioann/terraform.tfstate"
    region  = "eu-central-1"
    profile = "mfa"
  }
}