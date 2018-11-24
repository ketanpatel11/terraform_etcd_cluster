provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

variable "region" {
  description = "AWS Region"
}

variable "name" {
  default     = "etc-node"
  description = "name of etc node"
}

variable "etc_nodes" {
  default     = "3"
  description = "Number of etc nodes in cluster"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t1.micro"
}

variable "tags" {
  description = "A mapping of tags to assign with etcd cluster"
  default     = {}
}
