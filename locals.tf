locals {
  cloudinit_post_nodeadm = [
    {
      content_type = "application/node.eks.aws"
      content = <<-EOT
        ---
        ${yamlencode({
      apiVersion = "node.eks.aws/v1alpha1"
      kind       = "NodeConfig"
      spec = {
        kubelet = {
          config = var.max_pods_per_node != null ? {
            maxPods = var.max_pods_per_node
          } : null
          flags = [
            "--node-labels=node.kubernetes.io/instance-type=${var.node_instance_type}, environment=${var.env}"
          ]
        }
      }
})}
      EOT
}
]

common_tags = merge(
  var.tags,
  {
    bu_id  = var.bu_id
    app_id = var.app_id
    env    = var.env
  }
)
}
