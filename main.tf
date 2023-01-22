locals {
  tags                  = var.tags
  name                  = "cni-metrics-helper"
  service_account       = try(var.aws_vpc_cni_metrics_helm_config.service_account, local.name)
  version               = var.aws_vpc_cni_metrics_version
  eks_oidc_provider_arn = var.eks_oidc_provider_arn
  iam_policy_name       = "${var.eks_cluster_id}-cni-metrics-helper"
  image_registry        = var.image_registry != null ? var.image_registry : local.amazon_container_image_registry_uris[data.aws_region.current.name]
  role_name             = try(coalesce(var.role_name, local.name), "")
  log_level             = var.aws_vpc_cni_metrics_log_level


  default_helm_config = {
    name             = local.name
    chart            = local.name
    repository       = "https://aws.github.io/eks-charts"
    version          = "0.1.15"
    namespace        = "kube-system"
    create_namespace = false
    values           = null
    description      = "Helm Chart for cni-metrics-helper"
  }

  helm_config = merge(
    local.default_helm_config,
    var.aws_vpc_cni_metrics_helm_config
  )

  set_values = concat(
    [
      {
        name  = "serviceAccount.name"
        value = local.service_account
      },
      {
        name  = "serviceAccount.create"
        value = true
      },
      {
        name  = "env.AWS_VPC_K8S_CNI_LOGLEVEL"
        value = local.log_level
      },
      {
        name  = "image.override"
        value = "${local.image_registry}/cni-metrics-helper:${local.version}"
      },
      {
        name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
        value = module.aws_vpc_cni_metrics_irsa.iam_role_arn
      }
    ],
    try(var.aws_vpc_cni_metrics_helm_config.set_values, [])
  )

}

resource "helm_release" "this" {
  count = var.create_release ? 1 : 0

  name             = local.name
  chart            = local.name
  repository       = local.helm_config["repository"]
  version          = local.helm_config["version"]
  namespace        = local.helm_config["namespace"]
  create_namespace = local.helm_config["create_namespace"]
  values           = local.helm_config["values"]
  description      = "A Helm chart for the AWS VPC CNI Metrics Helper"

  /*
  set              = concat(local.set_values,[{
     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
     value = module.aws_vpc_cni_metrics_irsa.iam_role_arn
   }])
   */
  dynamic "set" {
    for_each = local.set_values

    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, null)
    }
  }

}


module "aws_vpc_cni_metrics_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name   = local.role_name
  create_role = var.create_role

  role_policy_arns = {
    cni_metrics = aws_iam_policy.this[0].arn
  }

  oidc_providers = {
    main = {
      provider_arn               = local.eks_oidc_provider_arn
      namespace_service_accounts = ["${local.helm_config["namespace"]}:${local.service_account}"]
    }
  }

  tags = local.tags
}



resource "aws_iam_policy" "this" {
  count = var.create_role ? 1 : 0

  name        = local.iam_policy_name
  description = "IAM policy for EKS CNI Metrics helper"
  path        = "/"
  policy      = data.aws_iam_policy_document.this[0].json

  tags = local.tags
}

data "aws_iam_policy_document" "this" {
  count = var.create_role ? 1 : 0

  statement {
    sid = "CNIMetrics"
    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeTags"
    ]
    resources = ["*"]
  }
}

data "aws_region" "current" {}

locals {

  # For addons that pull images from a region-specific ECR container registry by default
  # for more information see: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  amazon_container_image_registry_uris = {
    af-south-1     = "877085696533.dkr.ecr.af-south-1.amazonaws.com",
    ap-east-1      = "800184023465.dkr.ecr.ap-east-1.amazonaws.com",
    ap-northeast-1 = "602401143452.dkr.ecr.ap-northeast-1.amazonaws.com",
    ap-northeast-2 = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com",
    ap-northeast-3 = "602401143452.dkr.ecr.ap-northeast-3.amazonaws.com",
    ap-south-1     = "602401143452.dkr.ecr.ap-south-1.amazonaws.com",
    ap-southeast-1 = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com",
    ap-southeast-2 = "602401143452.dkr.ecr.ap-southeast-2.amazonaws.com",
    ap-southeast-3 = "296578399912.dkr.ecr.ap-southeast-3.amazonaws.com",
    ca-central-1   = "602401143452.dkr.ecr.ca-central-1.amazonaws.com",
    cn-north-1     = "918309763551.dkr.ecr.cn-north-1.amazonaws.com.cn",
    cn-northwest-1 = "961992271922.dkr.ecr.cn-northwest-1.amazonaws.com.cn",
    eu-central-1   = "602401143452.dkr.ecr.eu-central-1.amazonaws.com",
    eu-north-1     = "602401143452.dkr.ecr.eu-north-1.amazonaws.com",
    eu-south-1     = "590381155156.dkr.ecr.eu-south-1.amazonaws.com",
    eu-west-1      = "602401143452.dkr.ecr.eu-west-1.amazonaws.com",
    eu-west-2      = "602401143452.dkr.ecr.eu-west-2.amazonaws.com",
    eu-west-3      = "602401143452.dkr.ecr.eu-west-3.amazonaws.com",
    me-south-1     = "558608220178.dkr.ecr.me-south-1.amazonaws.com",
    me-central-1   = "759879836304.dkr.ecr.me-central-1.amazonaws.com",
    sa-east-1      = "602401143452.dkr.ecr.sa-east-1.amazonaws.com",
    us-east-1      = "602401143452.dkr.ecr.us-east-1.amazonaws.com",
    us-east-2      = "602401143452.dkr.ecr.us-east-2.amazonaws.com",
    us-gov-east-1  = "151742754352.dkr.ecr.us-gov-east-1.amazonaws.com",
    us-gov-west-1  = "013241004608.dkr.ecr.us-gov-west-1.amazonaws.com",
    us-west-1      = "602401143452.dkr.ecr.us-west-1.amazonaws.com",
    us-west-2      = "602401143452.dkr.ecr.us-west-2.amazonaws.com"
  }
}
