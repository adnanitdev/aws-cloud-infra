terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "terraform/eks-project/terraform.tfstate"
    region         = "your-region"
    dynamodb_table = "your-dynamodb-table"
    encrypt        = true
  }
}