
data "aws_ami" "eks" {
  # checkov:skip=CKV_AWS_386:Using standard EKS AMI pattern
  most_recent = true
  owners      = ["amazon"] #Trust this owner to ensure that ami published is only by AMAZON

  filter {
    name = "name"
    values = [
      var.ami_type == "AL2023_x86_64_STANDARD"
      ? "amazon-eks-node-al2023-x86_64-standard-${var.cluster_kubernetes_version}-*"
      : "amazon-eks-node-${var.cluster_kubernetes_version}-v*"
    ]
  }
}
