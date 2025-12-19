

resource "aws_iam_user_policy_attachment" "eks_cluster" {
  user       = aws_iam_user.eks_ecr_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_user_policy_attachment" "eks_service" {
  user       = aws_iam_user.eks_ecr_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_user_policy_attachment" "ecr" {
  user       = aws_iam_user.eks_ecr_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
