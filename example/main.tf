################################################################################
# EKS Module
################################################################################

module "eks" {
  source = "../"

  cluster_kubernetes_version = "1.30"
  vpc_id                     = "<vpc-id>"                       # Placeholder
  private_subnet_ids         = ["<subnet-id1>", "<subnet-id2>"] # Placeholder
  env                        = "dev"
  bu_id                      = "oc"
  app_id                     = "eks"

  ami_type = "AL2023_x86_64_STANDARD"


  node_instance_type = "t3.small"
  desired_size       = 2
  min_size           = 1
  max_size           = 3

  tags = local.tags
}
