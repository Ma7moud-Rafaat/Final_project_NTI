#!/usr/bin/env bash
set -euo pipefail
source scripts/lib.sh

need_var INGRESS_NS
kube_setup

log "Delete ingresses"
kubectl -n argocd delete ingress argocd-ing --ignore-not-found=true || true
kubectl -n vault delete ingress vault-ing --ignore-not-found=true || true
kubectl -n nexus delete ingress nexus-ing --ignore-not-found=true || true

log "Helm uninstall apps/controllers"
helm -n argocd uninstall argocd || true
helm -n vault uninstall vault || true
helm -n nexus uninstall nexus || true
helm -n "$INGRESS_NS" uninstall ingress-nginx || true
helm -n kube-system uninstall aws-load-balancer-controller || true

log "Delete TargetGroupBinding + namespaces"
kubectl -n "$INGRESS_NS" delete targetgroupbinding ingress-nginx-tgb --ignore-not-found=true || true
# kubectl delete ns argocd vault nexus "$INGRESS_NS" --ignore-not-found=true || true
