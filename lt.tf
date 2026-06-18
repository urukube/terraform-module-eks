resource "aws_launch_template" "template" {
  name_prefix            = "${var.bu_id}-${var.app_id}-lt-"
  image_id               = data.aws_ami.eks.id
  instance_type          = var.node_instance_type
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      encrypted   = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = compact([var.node_security_group_id])
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }
}
