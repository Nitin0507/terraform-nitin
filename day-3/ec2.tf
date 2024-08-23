resource "aws_instance" "prod" {
    ami = "ami-02b49a24cfb95941c"
    instance_type = "t2.nano"
    key_name = "mumbai"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
    tags = {
      Name = "myec2"
    }


}
