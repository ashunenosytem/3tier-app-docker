terraform {
  backend "s3" {
    bucket         = "ansible-playbook-back"
    key            = "t1/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
