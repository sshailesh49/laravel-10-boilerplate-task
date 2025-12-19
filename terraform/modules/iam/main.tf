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
