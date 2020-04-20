variable "name" {
  type        = string
  default     = "cluster"
  description = "Name of ECS Cluster"
}

variable "tags" {
  type = list(object({
    charge_code = number
    environment = string
    opco        = string
  }))
  default = [
    {
      charge_code = 99999
      environment = ""
      opco        = ""
    }
  ]
}

variable "subnets" {
  type        = list
  default     = []
  description = "VPC Subnet IDs to Launch Resources into."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "VPC ID to Launch Resources into."
}

variable "ondemand_percentage" {
  type        = number
  default     = 0
  description = "Percentage of on-demand instances to use compared to spot instances. Default is 0% (i.e 100% spot instances)"
}

variable "min_num_instances" {
  type        = number
  default     = 1
  description = "Minimum amount of instances the ECS Cluster should ever have. Default is 1."
}

variable "max_num_instances" {
  type        = number
  default     = 1
  description = "Maximum amount of instances the ECS Cluster should ever have. Default is 1."
}

variable "desired_num_instances" {
  type        = number
  default     = 1
  description = "Desired amount of instances the ECS Cluster once equilibrium has been reached. Default is 1."
}

variable "instance_types_to_use" {
  type = list(object({
    type   = string
    weight = number
  }))
  default = [
    {
      type   = "t3.micro"
      weight = 1
    }
  ]
  description = "A list of maps; of acceptable instance types and their weights, to use in the ECS cluster. Default is t3.micro:1 only."
}