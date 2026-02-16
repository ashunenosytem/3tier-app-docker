variable "vpc_cidr" {
  type = string
}
variable "project_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
