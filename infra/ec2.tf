resource "aws_instance" "public" {
  ami           = data.aws_ssm_parameter.al2023_ami.value
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "bastionNew"
  user_data = file("${path.module}/../script.sh")
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "public-host"
  }
}
