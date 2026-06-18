output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate authority data for the cluster to communicate with the API server"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "Name of the cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the cluster API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_asg_names" {
  description = "List of Auto Scaling Group names for the cluster nodes"
  # value       = module.eks.cluster_asg
  value = []
}

output "cluster_primary_security_group_id" {
  description = "ID of the primary security group for the cluster nodes"
  value       = module.eks.cluster_security_group_id
}

output "cluster_oidc_provider_arn" {
  description = "ARN of the OIDC issuer for the cluster"
  value       = module.eks.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  description = "URL of the OIDC issuer for the cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_service_cidr" {
  description = "Service CIDR for the cluster"
  value       = module.eks.cluster_service_cidr
}
