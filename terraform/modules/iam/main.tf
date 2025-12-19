resource "aws_iam_user" "eks_ecr_user" {
  name = "eks-ecr-evaluator"
}

resource "aws_iam_policy" "eks_full_access" {
  name        = "eks-full-access"
  path        = "/"
  description = "Provides full access to Amazon EKS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "eks:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "eks" {
  user       = aws_iam_user.eks_ecr_user.name
  policy_arn = aws_iam_policy.eks_full_access.arn
}

resource "aws_iam_user_policy_attachment" "ecr" {
  user       = aws_iam_user.eks_ecr_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "eks_admin_role" {
  name = "EKSAdminRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:AdityaPdev-eng/laravel-10-boilerplate-task:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin_full_access" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = aws_iam_policy.eks_full_access.arn
}

resource "aws_iam_role_policy_attachment" "eks_admin_ecr" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
