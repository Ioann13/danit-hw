module "external_dns_argo_helm" {
  source = "../../modules/eks-external-dns"

  enabled           = true
  argo_enabled      = true
  argo_helm_enabled = true

  cluster_identity_oidc_issuer     = module.eks_cluster.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn

  helm_release_name = "aws-ext-dns-argo-kubernetes"
  namespace         = "aws-external-dns-argo-kubernetes"
  argo_namespace    = "argocd"

  argo_spec = {
    source = {
      repoURL        = "https://github.com/Omarovskyi/FinalStepProject.git"
      targetRevision = "HEAD"
      path           = "k8s"
    }
    destination = {
      server    = "https://kubernetes.default.svc"
      namespace = "aws-external-dns-argo-kubernetes"
    }
  }

  argo_sync_policy = {
    automated = {
      prune    = true
      selfHeal = true
    }
    syncOptions = ["CreateNamespace=true"]
  }
}