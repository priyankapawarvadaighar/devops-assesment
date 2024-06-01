provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ipfs_node" {
  count         = 1
  ami           = "ami-0d61df7ffa57e2673" # Replace with the AMI ID created by Packer
  instance_type = "t2.micro"
  key_name      = "assesment" # Replace with your key pair name


  tags = {
    Name = "ipfs-node-${count.index}"
  }
}

output "ipfs_node_ips" {
  value = aws_instance.ipfs_node[*].public_ip
}

