terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
access_key ="AKIARGKJVQHUDAONK3PV"
secret_key ="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"
}

resource "aws_instance" "aws-jenkins-ec2" {
  ami = "ami-0d7a109bf30624c99"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  tags = {
    Name = "Jenkins_Server"
  }

user_data = <<-EOF
#!bin/bash
    sudo yum update -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade
    sudo amazon-linux-extras install java-openjdk11 -y
    sudo dnf install java-11-amazon-corretto -y
    sudo yum install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
  EOF
}

resource "aws_security_group" "jenkins_security" {
  name = "jenkins-security"
  vpc_id = "vpc-0f44e265ed34f5383"

 ingress  {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

 ingress  {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

 ingress  {
    description = "Incoming 443"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

 egress   {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }

}
