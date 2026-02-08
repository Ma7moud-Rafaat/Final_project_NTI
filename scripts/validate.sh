#!/usr/bin/env bash
set -euo pipefail
source ci/scripts/lib.sh

need_var INGRESS_NS
need_var INGRESS_SVC
kube_setup

log "ingress-nginx svc/pods"
kubectl -n "$INGRESS_NS" get svc,pods -o wide

log "TargetGroupBinding describe"
kubectl -n "$INGRESS_NS" describe targetgroupbinding ingress-nginx-tgb | sed -n '1,260p'

log "ingresses"
kubectl get ingress -A -o wide

log "apps pods"
kubectl -n argocd get pods
kubectl -n vault get pods
kubectl -n nexus get pods

log "services (for sanity)"
kubectl -n argocd get svc argocd-server -o wide
kubectl -n vault get svc vault -o wide
kubectl -n nexus get svc -o wide
