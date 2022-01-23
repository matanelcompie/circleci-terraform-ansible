# 01. bastion server
resource "aws_security_group" "bastion_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "bastion_sg"
  description = "bastion_sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion_sg",
    Owner = "matanel"
  }
}

# 02. private server
resource "aws_security_group" "private_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "private_sg"
  description = "private_sg"
  ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = [aws_security_group.bastion_sg.id] 
      } 
  ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
      }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_security_group.bastion_sg]  
  tags = {
    Name = "private_sg",
    Owner = "matanel"
  }
}