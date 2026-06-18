################ORG INFO##########################

variable "bu_id" {
  type        = string
  description = "Business Unit ID to use for the cluster"
  default     = null
}

variable "app_id" {
  type        = string
  description = "Application ID to use for the cluster"
  default     = null
}

variable "friendly_name" {
  type        = string
  description = "Friendly name for the cluster"
  default     = "root"
}

variable "env" {
  type        = string
  description = "Environment to use for the cluster"
}

##################################################

################NETWORKING INFO###################

variable "vpc_id" {
  description = "VPC ID to use for the cluster"
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs where the EKS cluster nodes/ENIs will be created."
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs where the EKS cluster nodes/ENIs will be created."
  default     = []
}

##################################################

################CLUSTER INFO######################

variable "cluster_access_entries" {
  description = "Map of cluster access entries to use for the cluster"
  type        = any
  default     = {}
}

variable "cluster_endpoint_access_type" {
  description = <<-EOT
    Type of API server endpoint access:
    - "private": Only private endpoint (accessible only within VPC/VPN)
    - "private_with_public_cidrs": Private endpoint + public restricted to specific CIDRs
    - "public": Public endpoint open to all (0.0.0.0/0), no private access
  EOT
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "private_with_public_cidrs", "public"], var.cluster_endpoint_access_type)
    error_message = "cluster_endpoint_access_type must be 'private', 'private_with_public_cidrs', or 'public'"
  }
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks allowed to access the public API server endpoint. Required when access_type is 'private_with_public_cidrs'."
  type        = list(string)
  default     = []
}


variable "cluster_kubernetes_version" {
  description = "Kubernetes <major>.<minor> version to use for the cluster"
  type        = string
  default     = "1.30"
}

variable "cluster_control_plane_subnet_ids" {
  description = "List of subnet IDs to use for the cluster control plane"
  type        = list(string)
  default     = null
}

# Optional: Security group is created by EKS automatically which whitelists/enables communication between EKS control plane and worker nodes
# If you want to add additional security group rules, you can use this variable
variable "node_security_group_id" {
  description = "Security group ID from the networking module to attach to EKS nodes (in addition to the default one)"
  type        = string
  default     = null
}

variable "control_plane_security_group_id" {
  description = "Security group ID from the networking module to attach to the EKS control plane (in addition to the default one)"
  type        = string
  default     = null
}

variable "cluster_enabled_log_types" {
  description = "List of log types to enable for the cluster"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cloudinit_pre_nodeadm" {
  description = "Optional: Cloudinit pre-nodeadm script to use for the cluster"
  type = list(object({
    content_type = string
    content      = string
  }))
  default = []
}

variable "cloudinit_post_nodeadm" {
  description = "Optional: Cloudinit post-nodeadm script to use for the cluster"
  type = list(object({
    content_type = string
    content      = string
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "iam_role_permissions_boundary" {
  description = "IAM role permissions boundary to use for the cluster"
  type        = string
  default     = null
}

variable "ami_type" {
  description = "AMI type to use for the cluster"
  type        = string
  default     = "AL2023_x86_64_STANDARD"

  validation {
    condition     = can(regex("^AL2023_x86_64_STANDARD|AL2_x86_64$", var.ami_type))
    error_message = "AMI type must be AL2023_x86_64_STANDARD or AL2_x86_64"
  }
}

variable "node_instance_type" {
  description = "Instance type to use for the cluster nodes"
  type        = string
  default     = "t3.medium"
}

variable "min_size" {
  description = "Minimum number of nodes to use for the cluster nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes to use for the cluster nodes"
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired number of nodes to use for the cluster nodes"
  type        = number
  default     = 2
}

variable "max_pods_per_node" {
  description = "Maximum number of pods to use for the cluster nodes"
  type        = number
  default     = 30
}

# True: If you want to use EKS to manage your node group.
#       Automated Lifecycle: AWS creates and manages the EC2 Auto Scaling Group (ASG) for you.
#       Easy Upgrades: One-click rolling updates. AWS automatically cordons, drains, and terminates nodes to replace them with new versions.
# False: If you want to manage your node group yourself.
#       Manual Lifecycle: You define and manage the ASG yourself using Terraform (like in your current code).
#       Manual Upgrades: You are responsible for cycling nodes (cordoning, draining, and terminating) during upgrades or utilizing ASG "Instance Refresh" features manually.
variable "is_eks_managed_node_group" {
  description = "Boolean to enable or disable the EKS node group"
  type        = bool
  default     = false
}
