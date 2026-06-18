## Usage

```hcl
module "eks" {
  source = "github.com/orbitcluster/oc-terraform-module-eks"

  cluster_name = "example-cluster"
  env          = "dev"
  vpc_id = "vpc-12345678"
  bu_id  = "oc"
  app_id = "eks"

  private_subnet_ids = ["subnet-12345678", "subnet-87654321"]

  extra_nodegroups = {
    "example-ng" = "t3.medium"
  }
}

## Development

### Pre-commit Hooks

This repository uses [pre-commit](https://pre-commit.com/) to ensure code quality and security.

1.  **Install pre-commit**:
    ```bash
    pip install pre-commit
    ```
2.  **Install hooks**:
    ```bash
    pre-commit install
    ```
3.  **Run checks**:
    ```bash
    pre-commit run --all-files
    ```

### Testing

This module uses native Terraform testing (`terraform test`).

To run tests locally:

1.  Ensure you have AWS credentials configured.
2.  Run the tests:
    ```bash
    terraform test
    ```

## CI/CD

This repository uses GitHub Actions for automated testing and release management.

### Workflows

*   **CI**: Triggered on push to any branch and pull requests.
    *   Runs `terraform validate`.
    *   Runs `terraform test` (configuring AWS credentials via secrets).
*   **Release**: Triggered on push to `main`.
    *   Uses [Semantic Release](https://github.com/semantic-release/semantic-release) to analyze commit messages.
    *   Automatically creates a new version tag and GitHub release.

### Secrets

The following GitHub Secrets are required for the CI to function:

*   `OC_ACCESS_KEY_ID`: AWS Access Key ID.
*   `OC_SECRET_ACCESS_KEY`: AWS Secret Access Key.
*   `OC_ROLE_TO_ASSUME`: ARN of the IAM role to assume (e.g., `arn:aws:iam::ACCOUNT_ID:role/OrbitClusterEKSAdmin`).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.15.0, <= 6.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.15.0, <= 6.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 21.0 |

## Resources

| Name | Type |
|------|------|
| [aws_launch_template.template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group_rule.allow_all_subnet_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | AMI type to use for the cluster | `string` | `"AL2023_x86_64_STANDARD"` | no |
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | Application ID to use for the cluster | `string` | `null` | no |
| <a name="input_bu_id"></a> [bu\_id](#input\_bu\_id) | Business Unit ID to use for the cluster | `string` | `null` | no |
| <a name="input_cloudinit_post_nodeadm"></a> [cloudinit\_post\_nodeadm](#input\_cloudinit\_post\_nodeadm) | Optional: Cloudinit post-nodeadm script to use for the cluster | <pre>list(object({<br/>    content_type = string<br/>    content      = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cloudinit_pre_nodeadm"></a> [cloudinit\_pre\_nodeadm](#input\_cloudinit\_pre\_nodeadm) | Optional: Cloudinit pre-nodeadm script to use for the cluster | <pre>list(object({<br/>    content_type = string<br/>    content      = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_access_entries"></a> [cluster\_access\_entries](#input\_cluster\_access\_entries) | Map of cluster access entries to use for the cluster | `any` | `{}` | no |
| <a name="input_cluster_control_plane_subnet_ids"></a> [cluster\_control\_plane\_subnet\_ids](#input\_cluster\_control\_plane\_subnet\_ids) | List of subnet IDs to use for the cluster control plane | `list(string)` | `null` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | List of log types to enable for the cluster | `list(string)` | <pre>[<br/>  "api",<br/>  "audit",<br/>  "authenticator",<br/>  "controllerManager",<br/>  "scheduler"<br/>]</pre> | no |
| <a name="input_cluster_endpoint_access_type"></a> [cluster\_endpoint\_access\_type](#input\_cluster\_endpoint\_access\_type) | Type of API server endpoint access:<br/>- "private": Only private endpoint (accessible only within VPC/VPN)<br/>- "private\_with\_public\_cidrs": Private endpoint + public restricted to specific CIDRs<br/>- "public": Public endpoint open to all (0.0.0.0/0), no private access | `string` | `"private"` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks allowed to access the public API server endpoint. Required when access\_type is 'private\_with\_public\_cidrs'. | `list(string)` | `[]` | no |
| <a name="input_cluster_kubernetes_version"></a> [cluster\_kubernetes\_version](#input\_cluster\_kubernetes\_version) | Kubernetes <major>.<minor> version to use for the cluster | `string` | `"1.30"` | no |
| <a name="input_control_plane_security_group_id"></a> [control\_plane\_security\_group\_id](#input\_control\_plane\_security\_group\_id) | Security group ID from the networking module to attach to the EKS control plane (in addition to the default one) | `string` | `null` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Desired number of nodes to use for the cluster nodes | `number` | `2` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment to use for the cluster | `string` | n/a | yes |
| <a name="input_friendly_name"></a> [friendly\_name](#input\_friendly\_name) | Friendly name for the cluster | `string` | `"root"` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | IAM role permissions boundary to use for the cluster | `string` | `null` | no |
| <a name="input_is_eks_managed_node_group"></a> [is\_eks\_managed\_node\_group](#input\_is\_eks\_managed\_node\_group) | Boolean to enable or disable the EKS node group | `bool` | `false` | no |
| <a name="input_max_pods_per_node"></a> [max\_pods\_per\_node](#input\_max\_pods\_per\_node) | Maximum number of pods to use for the cluster nodes | `number` | `30` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of nodes to use for the cluster nodes | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of nodes to use for the cluster nodes | `number` | `2` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Instance type to use for the cluster nodes | `string` | `"t3.medium"` | no |
| <a name="input_node_security_group_id"></a> [node\_security\_group\_id](#input\_node\_security\_group\_id) | Security group ID from the networking module to attach to EKS nodes (in addition to the default one) | `string` | `null` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | List of private subnet CIDRs where the EKS cluster nodes/ENIs will be created. | `list(string)` | `[]` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs where the EKS cluster nodes/ENIs will be created. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to use for the cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_asg_names"></a> [cluster\_asg\_names](#output\_cluster\_asg\_names) | List of Auto Scaling Group names for the cluster nodes |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate authority data for the cluster to communicate with the API server |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for the cluster API server |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the cluster |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | URL of the OIDC issuer for the cluster |
| <a name="output_cluster_oidc_provider_arn"></a> [cluster\_oidc\_provider\_arn](#output\_cluster\_oidc\_provider\_arn) | ARN of the OIDC issuer for the cluster |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | ID of the primary security group for the cluster nodes |
| <a name="output_cluster_service_cidr"></a> [cluster\_service\_cidr](#output\_cluster\_service\_cidr) | Service CIDR for the cluster |
<!-- END_TF_DOCS -->
