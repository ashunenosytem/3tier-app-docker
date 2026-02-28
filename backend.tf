terraform {
  backend "s3" {
    bucket         = "ansible-playbook-back"
    key            = "t1/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
    encrypt        = true
  }
}
