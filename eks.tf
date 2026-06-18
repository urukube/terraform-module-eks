
module "eks" {
  # checkov:skip=CKV_TF_1:Using version tags for modules
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.friendly_name}-${var.bu_id}-${var.app_id}-eks"
  kubernetes_version = var.cluster_kubernetes_version
  enabled_log_types  = var.cluster_enabled_log_types
  # checkov:skip=CKV_TF_1:Using version tags for modules
  # checkov:skip=CKV_AWS_260:Public access required
  additional_security_group_ids = compact([var.control_plane_security_group_id])

  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true
  tags                                     = local.common_tags

  addons = {
    kube-proxy = {
      most_recent = true
    }
  }

  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  control_plane_subnet_ids      = coalesce(var.cluster_control_plane_subnet_ids, var.private_subnet_ids)
  subnet_ids                    = var.private_subnet_ids
  vpc_id                        = var.vpc_id

  access_entries = var.cluster_access_entries

  # Endpoint Access Configuration (derived from access_type)
  # private: private=true, public=false
  # private_with_public_cidrs: private=true, public=true with restricted CIDRs
  # public: private=false, public=true with 0.0.0.0/0
  endpoint_private_access = var.cluster_endpoint_access_type != "public"
  endpoint_public_access  = var.cluster_endpoint_access_type != "private"
  endpoint_public_access_cidrs = (
    var.cluster_endpoint_access_type == "public" ? ["0.0.0.0/0"] :
    var.cluster_endpoint_access_type == "private_with_public_cidrs" ? var.cluster_endpoint_public_access_cidrs :
    []
  )

  # TODO: add eks_managed_node_groups block for when is_eks_managed_node_group = true
  self_managed_node_groups = var.is_eks_managed_node_group ? null : {
    default = {
      # The node group name gets appended with "-node-group" suffix
      name     = "${var.friendly_name}-${var.bu_id}-${var.app_id}-sm"
      ami_type = var.ami_type

      launch_template_id      = aws_launch_template.template.id
      launch_template_version = aws_launch_template.template.latest_version

      autoscaling_group_tags = {
        "k8s.io/cluster-autoscaler/enabled"                                             = "true"
        "k8s.io/cluster-autoscaler/${var.friendly_name}-${var.bu_id}-${var.app_id}-eks" = "owned"
      }

      iam_role_additional_policies = {
        ssm        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        cloudwatch = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      }

      iam_role_attach_cni_policy    = true
      iam_role_permissions_boundary = var.iam_role_permissions_boundary
      pre_bootstrap_user_data       = file("${path.module}/pre-bootstrap-user-data.sh")
      enable_bootstrap_user_data    = true
      bootstrap_extra_args          = var.ami_type == "AL2_x86_64" ? "--kubelet-extra-args=--node-labels=node.kubernetes.io/instance-type=${var.node_instance_type}, environment=${var.env}" : null
      cloudinit_post_nodeadm        = var.ami_type == "AL2_x86_64" ? [] : coalesce(var.cloudinit_post_nodeadm, local.cloudinit_post_nodeadm)
      cloudinit_pre_nodeadm         = var.cloudinit_pre_nodeadm
      launch_template_tags = {
        Environment  = var.env
        BusinessUnit = var.bu_id
        Application  = var.app_id
      }
      min_size      = var.min_size
      max_size      = var.max_size
      desired_size  = var.desired_size
      tags          = local.common_tags
      capacity_type = "ON_DEMAND"
    }
  }


}

resource "aws_vpc_security_group_ingress_rule" "allow_all_subnet_traffic" {
  for_each          = toset(var.private_subnet_cidrs)
  security_group_id = module.eks.cluster_security_group_id
  cidr_ipv4         = each.value
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow HTTPS from routable subnets to EKS control plane"
}
