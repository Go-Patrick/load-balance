resource "aws_instance" "vps1" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  user_data       = filebase64("userdata.tpl")
  key_name        = "test_my_key"
  security_groups = [aws_security_group.load_sg.id]
  subnet_id       = aws_subnet.public1.id

  tags = {
    Name = "load-1"
  }
}

resource "aws_instance" "vps2" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  user_data       = filebase64("userdata.tpl")
  key_name        = "test_my_key"
  security_groups = [aws_security_group.load_sg.id]
  subnet_id       = aws_subnet.public2.id

  tags = {
    Name = "load-1"
  }
}