variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  
}
variable "environment" {
  description = "The environment for the VPC"
  type        = string
}
variable "project_name" {
  description = "The project name for the VPC"
  type        = string
}
variable "vpc_tags" {
  description = "A map of tags to assign to the VPC"
  type        = map
  default     = {}
}

variable "igw_tags" {
  description = "A map of tags to assign to the Internet Gateway"
  type        = map
  default     = {}
}

#-------------------- Subnet variables --------------------#
variable "public_subnet_cidrs" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "private_subnet_cidrs" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
  default     = ["10.0.11.0/24","10.0.12.0/24"]
}
variable "private_subnet_tags" {
  description = "A map of tags to assign to the private subnet"
  type        = map
  default     = {}
}
variable "public_subnet_tags" {
  description = "A map of tags to assign to the public subnet"
  type        = map
  default     = {}
}
variable "database_subnet_cidrs" {
  description = "The CIDR block for the database subnet"
  type        = list(string)
  default     = ["10.0.21.0/24","10.0.22.0/24"]
}
variable "database_subnet_tags" {
  description = "A map of tags to assign to the database subnet"
  type        = map
  default     = {}
}

variable "is_peering_required" {
  description = "A boolean variable to determine if VPC peering is required"
  type        = bool
  default     = false
}
variable "vpc_peering_tags" {
  description = "A map of tags to assign to the VPC peering connection"
  type        = map
  default     = {}
}