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