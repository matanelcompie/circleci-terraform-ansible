# Create 3 instances - one public and two private

# 01. public
resource "aws_instance" "bastion" {
  ami           = var.ami["${var.aws_region}"]
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_sub.id                      
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]    
  key_name = aws_key_pair.instance.key_name
  depends_on = [
    aws_instance.private,
  ]
  tags = {
    Name = "bastion",
    Owner = "matanel"
  }   
}

# 02. private
resource "aws_instance" "private" {
  ami           = var.ami["${var.aws_region}"]
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_sub.id                
  vpc_security_group_ids = [aws_security_group.private_sg.id] 
  key_name = aws_key_pair.instance.key_name  
  depends_on = [
    aws_internet_gateway.igw,
  ]
  tags = {
    Name = "private",
    Owner = "matanel"
  }   
}
