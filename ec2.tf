resource "aws_instance" "gawrgare-test-terraform" {
    ami           = "ami-0ddbdea833a8d2f0d"
    instance_type = "t2.micro"  

    tags = {
      Name = "gawrgare-test-terraform"
      ManagedBy = "Terraform"
    }
}