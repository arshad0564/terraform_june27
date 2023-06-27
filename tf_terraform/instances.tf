resource "aws_instance" "jenkins_terraform_aws" {
  ami           = "ami-0331ebbf81138e4de"
  instance_type = "t2.micro"
  tags = {
    Name = "jenkins_terraform"
  }
}
