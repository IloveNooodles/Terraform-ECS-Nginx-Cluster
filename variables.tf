variable "aws_access_key_id" {
  description = "Your aws access key id"
  type        = string
}

variable "aws_secret_access_key" {
  description = "Your aws secreet access key"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "ap-southeast-1"
  type        = string
}

variable "app_type" {
  description = "Application configuration"
  type = object({
    image = string
    count = number
    port  = number
  })
  default = {
    image = "nginx:latest"
    count = 2
    port  = 80
  }
}


variable "health_check_path" {
  description = "Path for healthcheck"
  type        = string
  default     = "/"
}

variable "launch_type" {
  description = "ECS Launch type. (1vCPU = 1024, memory in MiB)"
  type = object({
    type   = string
    cpu    = number
    memory = number
  })
  default = {
    type   = "Fargate"
    cpu    = 1024
    memory = 2048
  }
}
