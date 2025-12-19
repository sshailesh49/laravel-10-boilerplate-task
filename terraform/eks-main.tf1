resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = <<EOF
- userarn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${module.iam.iam_user_name}
  username: ${module.iam.iam_user_name}
  groups:
    - system:masters
EOF
  }

  depends_on = [
    module.eks
  ]
}

data "aws_caller_identity" "current" {}
