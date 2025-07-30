module "eks-external-dns" {
  source                           = "./modules/eks-external-dns"
  cluster_identity_oidc_issuer     = aws_eks_cluster.danit.identity[0].oidc[0].issuer
  cluster_identity_oidc_issuer_arn = module.oidc-provider-data.arn

  rbac_create             = true
  service_account_create  = true
  service_account_name    = "external-dns"
  irsa_role_create        = true
  policy_allowed_zone_ids = ["Z02537122N3YB2GRT9YY1"]

  helm_release_name     = "external-dns-martianov"
  irsa_role_name_prefix = "external-dns-irsa-martianov"

  settings = {
    provider    = "aws"
    policy      = "sync"
    registry    = "txt"
    txtOwnerId  = "martianov-devops7"
    awsZoneType = "public"
    logLevel    = "debug"
  }
}