variable "aws_region" {
  default = "us-east-1"
}

variable "ami" {
    type = map(string)
    default = {
        "us-east-1" = "ami-04505e74c0741db8d"
        "eu-central-1" = "ami-0d527b8c289b4af7f"
    }
}

variable "users" {
  type = map(string)
  default = {
    "ubuntu" = "ubuntu"
  }
}