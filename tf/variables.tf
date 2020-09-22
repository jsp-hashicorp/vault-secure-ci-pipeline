variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "ap-northeast-2"
}
variable "ami" {
    default = "ami-0e1e385b0a934254a"
}
variable "hello_tf_instance_count" {
    default = 1
}
variable "hello_tf_instance_type" {
    default = "t2.micro"
}
