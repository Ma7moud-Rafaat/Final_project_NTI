#!/usr/bin/env bash
set -euo pipefail
source ci/scripts/lib.sh

kube_setup

log "Deploy ArgoCD"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
retry 5 3 helm repo add argo https://argoproj.github.io/argo-helm
retry 5 3 helm repo update
helm upgrade --install argocd argo/argo-cd -n argocd
kubectl -n argocd rollout status deploy/argocd-server --timeout=600s || true

log "Deploy Vault (dev)"
kubectl create namespace vault --dry-run=client -o yaml | kubectl apply -f -
retry 5 3 helm repo add hashicorp https://helm.releases.hashicorp.com
retry 5 3 helm repo update
helm upgrade --install vault hashicorp/vault -n vault --set server.dev.enabled=true
kubectl -n vault get pods

log "Deploy Nexus"
kubectl create namespace nexus --dry-run=client -o yaml | kubectl apply -f -
retry 5 3 helm repo add sonatype https://sonatype.github.io/helm3-charts/
retry 5 3 helm repo update
helm upgrade --install nexus sonatype/nexus-repository-manager -n nexus
kubectl -n nexus get pods
