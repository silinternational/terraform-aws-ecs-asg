
module "ecsasg" {
  source             = "../"
  cluster_name       = "cluster_name"
  subnet_ids         = [aws_subnet.private_subnet.id]
  security_group_ids = [aws_vpc.vpc.default_security_group_id]
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
}
