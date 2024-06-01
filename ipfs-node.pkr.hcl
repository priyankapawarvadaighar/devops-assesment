packer {
  required_version = ">= 1.5.0"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "example" {
  region = var.aws_region
  source_ami_filter {
    filters = {
      "virtualization-type" = "hvm"
      "name"                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      "root-device-type"    = "ebs"
    }
    owners      = ["679593333241"]
    most_recent = true
  }

  instance_type = "t2.micro"
  ssh_username  = "ubuntu"
  ami_name      = "ipfs-node-ami-{{timestamp}}"
  
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y wget",
      "wget https://dist.ipfs.io/go-ipfs/v0.8.0/go-ipfs_v0.8.0_linux-amd64.tar.gz",
      "tar -xvzf go-ipfs_v0.8.0_linux-amd64.tar.gz",
      "cd go-ipfs && sudo bash install.sh",
      "ipfs init",
      # Create systemd service file for IPFS
      <<-EOF
sudo tee /etc/systemd/system/ipfs.service >/dev/null <<'END'
[Unit]
Description=IPFS Daemon
After=network.target

[Service]
ExecStart=/usr/local/bin/ipfs daemon
User=ubuntu
Group=ubuntu

[Install]
WantedBy=default.target
END
EOF
      ,
      # Reload systemd and start the IPFS service
      "sudo systemctl daemon-reload",
      "sudo systemctl enable ipfs",
      "sudo systemctl start ipfs"
    ]
  }
}
