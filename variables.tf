variable "aws_vpc_cni_metrics_helm_config" {
  description = "AWS VPC CNI MetricsHelm Chart config"
  type        = any
  default     = {}
}

variable "aws_vpc_cni_metrics_version" {
  description = "AWS VPC CNI Metrics image version"
  type        = string
  default     = "v1.12.1"
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
  type        = map(string)
  default     = {}
}

variable "eks_cluster_id" {
  description = "Cluster Name"
  type        = string
  default     = "eks-cluster"
}

variable "eks_oidc_provider_arn" {
  description = "Cluster EKS OIDC provider arn"
  type        = string
}

variable "image_registry" {
  description = "Custom image registry"
  type        = string
  default     = null 
  }

variable "create_role" {
  description = "Whether to create a role"
  type        = bool
  default     = true
}

variable "role_name" {
  description = "Name of IAM role"
  type        = string
  default     = null
}

variable "create_release" {
  description = "Determines whether the Helm release is created"
  type        = bool
  default     = true
}
