variable "aws_access_key_id" {
  description = "Your aws access key id"
  type        = string
}

variable "aws_secret_access_key" {
  description = "Your aws secret access key"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

# What image you want to build
# How many container should be spawned
# port
variable "app_type" {
  description = "Application and configuration"
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

variable "aws_launch_type" {
  description = "ECS Launch type. (1vCPU = 1024, memory in MiB)"
  type = object({
    type   = string
    cpu    = number
    memory = number
  })
  default = {
    type   = "FARGATE"
    cpu    = 256
    memory = 512
  }
}

variable "availability_zones_count" {
  description = "Many instance that will be created"
  type        = number
  default     = 2
}

variable "vpc_cidr_block" {
  description = "CIDR block for your vpc"
  type        = string
  default     = "172.16.0.0/16" # 16 bit hosts, 2^16 which is maximal
}

variable "autoscale_config" {
  description = "Configuration for app autoscaling target"
  type = object({
    min = number
    max = number
  })
  default = {
    min = 1
    max = 4
  }
}

variable "autoscale_metric" {
  description = "Configuration for cloud metric alarm"
  type = object({
    period             = string
    cooldown           = number
    evaluation_periods = string
    max_threshold      = string
    min_threshold      = string
    up                 = number
    down               = number
  })
  default = {
    period             = "120"
    cooldown           = 120
    evaluation_periods = "3"
    max_threshold      = "80"
    min_threshold      = "10"
    up                 = 1
    down               = -1
  }
}
