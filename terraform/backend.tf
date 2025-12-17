terraform {
  backend "s3" {
    bucket         = "vhonchar-terraform-state-eu"
    key            = "matrix-homeline/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks-eu"
    encrypt        = true
  }
}
