# https://ashwiniag.com/store-ssh-keys-in-aws-secret-manager-using-terraform/

resource "tls_private_key" "instance" {
  algorithm = "RSA"
}

resource "aws_key_pair" "instance" {
  key_name   = "keypair"
  public_key = tls_private_key.instance.public_key_openssh
  tags = {
    Name = "keypair",
    Owner = "matanel"
  }
}

# Creates and stores ssh key used creating an EC2 instance
resource "aws_secretsmanager_secret" "keypair" {
  name = "keypair"
}

resource "aws_secretsmanager_secret_version" "keypair" {
  secret_id     = aws_secretsmanager_secret.keypair.id
  secret_string = tls_private_key.instance.private_key_pem
}
