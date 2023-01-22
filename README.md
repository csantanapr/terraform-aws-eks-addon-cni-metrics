# AWS VPC CNI Metrics Helper 

The [Amazon VPC CNI plugin for Kubernetes metrics helper](https://docs.aws.amazon.com/eks/latest/userguide/cni-metrics-helper.html) is a tool that you can use to scrape network interface and IP address information, aggregate metrics at the cluster level, and publish the metrics to Amazon CloudWatch.

## Usage

### Create CNI Metric to existing EKS Cluster

```hcl
module "aws_vpc_cni_metrics" {
  source = "github.com/csantanapr/terraform-aws-eks-addon-cni-metrics"

  eks_cluster_id        = "my-eks-cluster"
  eks_oidc_provider_arn = "oidc.eks.us-west-2.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"

  # Optional
  aws_vpc_cni_metrics_version = "v1.12.1"

  # Optional
  aws_vpc_cni_metrics_log_level = "DEBUG"
  
  # Optional
  aws_vpc_cni_metrics_helm_config = {
    values = [
      <<-EOT
      env:
        AWS_CLUSTER_ID: "my-cni-metrics"
    EOT
    ]
  }

  tags = local.tags
}

```

## Examples

Examples codified under the [`examples`](https://github.com/csantanapr/terraform-aws-eks-addon-cni-metrics) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Complete](https://github.com/csantanapr/terraform-aws-eks-addon-cni-metrics/tree/main/examples/complete)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.10 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_vpc_cni_metrics_irsa"></a> [aws\_vpc\_cni\_metrics\_irsa](#module\_aws\_vpc\_cni\_metrics\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_vpc_cni_metrics_helm_config"></a> [aws\_vpc\_cni\_metrics\_helm\_config](#input\_aws\_vpc\_cni\_metrics\_helm\_config) | AWS VPC CNI MetricsHelm Chart config | `any` | `{}` | no |
| <a name="input_aws_vpc_cni_metrics_log_level"></a> [aws\_vpc\_cni\_metrics\_log\_level](#input\_aws\_vpc\_cni\_metrics\_log\_level) | AWS VPC CNI Metrics log level | `string` | `"INFO"` | no |
| <a name="input_aws_vpc_cni_metrics_version"></a> [aws\_vpc\_cni\_metrics\_version](#input\_aws\_vpc\_cni\_metrics\_version) | AWS VPC CNI Metrics image version | `string` | `"v1.12.1"` | no |
| <a name="input_create_release"></a> [create\_release](#input\_create\_release) | Determines whether the Helm release is created | `bool` | `true` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create a role | `bool` | `true` | no |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | Cluster Name | `string` | `"eks-cluster"` | no |
| <a name="input_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#input\_eks\_oidc\_provider\_arn) | Cluster EKS OIDC provider arn | `string` | n/a | yes |
| <a name="input_image_registry"></a> [image\_registry](#input\_image\_registry) | Custom image registry | `string` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of IAM role | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_version"></a> [app\_version](#output\_app\_version) | The version number of the application being deployed |
| <a name="output_chart"></a> [chart](#output\_chart) | The name of the chart |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of IAM role |
| <a name="output_iam_role_path"></a> [iam\_role\_path](#output\_iam\_role\_path) | Path of IAM role |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | Unique ID of IAM role |
| <a name="output_name"></a> [name](#output\_name) | Name is the name of the release |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Name of Kubernetes namespace |
| <a name="output_revision"></a> [revision](#output\_revision) | Version is an int32 which represents the version of the release |
| <a name="output_values"></a> [values](#output\_values) | The compounded values from `values` and `set*` attributes |
| <a name="output_version"></a> [version](#output\_version) | A SemVer 2 conformant version string of the chart |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
