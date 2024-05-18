variable "region" {
  description = "Please Enter AWS Region to deploy Server"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Enter Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list(any)
  default     = ["80", "443", "22", "8080"]
}
