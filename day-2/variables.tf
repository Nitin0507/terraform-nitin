variable "ami" {
  description = "passing valu  main.tf"
  type = string
  default = "ami-02b49a24cfb95941c"

}
variable "instance_type" {
  type = string
  default = "t2.micro"

}
variable "key_name" {
  type = string
  default = "mumbai"
}