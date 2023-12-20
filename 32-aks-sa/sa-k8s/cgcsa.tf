
resource "kubernetes_service_account" "cloudguard_controller" {
  metadata {
    name = "cloudguard-controller"
  }
}

resource "kubernetes_cluster_role" "endpoint_reader" {
  metadata {
    name = "endpoint-reader"
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "allow_cloudguard_access_endpoints" {
  metadata {
    name = "allow-cloudguard-access-endpoints"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.endpoint_reader.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cloudguard_controller.metadata[0].name
    namespace = "default"
  }
}

resource "kubernetes_cluster_role" "pod_reader" {
  metadata {
    name = "pod-reader"
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "allow_cloudguard_access_pods" {
  metadata {
    name = "allow-cloudguard-access-pods"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.pod_reader.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cloudguard_controller.metadata[0].name
    namespace = "default"
  }
}

resource "kubernetes_cluster_role" "service_reader" {
  metadata {
    name = "service-reader"
  }

  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "allow_cloudguard_access_services" {
  metadata {
    name = "allow-cloudguard-access-services"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.service_reader.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cloudguard_controller.metadata[0].name
    namespace = "default"
  }
}

resource "kubernetes_cluster_role" "node_reader" {
  metadata {
    name = "node-reader"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "allow_cloudguard_access_nodes" {
  metadata {
    name = "allow-cloudguard-access-nodes"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.node_reader.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cloudguard_controller.metadata[0].name
    namespace = "default"
  }
}

resource "kubernetes_secret" "cloudguard_controller" {
  metadata {
    name = "cloudguard-controller"
    annotations = {
      "kubernetes.io/service-account.name" = "cloudguard-controller"
    }
  }

  type = "kubernetes.io/service-account-token"
}
