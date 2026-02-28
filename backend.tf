terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # Using v6.x for the latest features and India (ap-south-1) optimizations
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "ansible-playbook-back"
    key            = "t1/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
    encrypt        = true
  }
}
