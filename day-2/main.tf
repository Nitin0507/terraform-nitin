resource "aws_instance" "dev" {
  ami = "ami-02b49a24cfb95941c"
  key_name = "mumbai"
  instance_type = "t2.micro"
   
 tags = {
   name = "test"
 }
}