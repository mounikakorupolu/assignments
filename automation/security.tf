//security.tf
resource "aws_security_group" "ingress-all-test" {
name = "allow-all-sg"
vpc_id = "${aws_vpc.test-env.id}"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 22
    to_port = 22
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
Here we define a security group that will allow anyone to connect through port 22. It will also forward all traffic without restriction. Using vpc_id we attach it to the VPC we have created. The ingress block is used to describe how incoming traffic will be treated. Here we have defined a rule to accept connections from all IPs on port 22. The egress block defines the rule for outgoing traffic and here we have defined it to allow all.
Launching EC2 instance
Now that we have most of it set up let’s launch our instance. For this we have to set up an aws_instance resource.
//servers.tf
resource "aws_instance" "test-ec2-instance" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.ami_key_pair_name}"
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
tags {
    Name = "${var.ami_name}"
  }
subnet_id = "${aws_subnet.subnet-uno.id}"
}
