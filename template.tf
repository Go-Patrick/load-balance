resource "aws_launch_template" "lauch" {
  key_name             = "test_my_key"
  image_id             = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  security_group_names = [aws_security_group.load_sg.name]

  network_interfaces {
    associate_public_ip_address = true
  }

  user_data = filebase64("userdata.tpl")
}