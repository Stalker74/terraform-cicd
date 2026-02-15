data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.instance_profile_name
  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
echo "<h1>Hello from ${var.environment}</h1>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF
  tags = { Name = "${var.project_name}-${var.environment}-web" }
}
