#!/usr/bin/env bash
set -euo pipefail
source ci/scripts/lib.sh

need_var INGRESS_NS
need_var INGRESS_SVC
need_var AWS_LBC_ROLE_ARN
kube_setup

log "Install/Upgrade AWS Load Balancer Controller"
retry 5 3 helm repo add eks https://aws.github.io/eks-charts
retry 5 3 helm repo update

kubectl -n kube-system get sa aws-load-balancer-controller >/dev/null 2>&1 || \
  kubectl -n kube-system create sa aws-load-balancer-controller

kubectl -n kube-system annotate sa aws-load-balancer-controller \
  eks.amazonaws.com/role-arn="$AWS_LBC_ROLE_ARN" --overwrite

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="$EKS_CLUSTER_NAME" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

kubectl -n kube-system rollout status deploy/aws-load-balancer-controller --timeout=600s

log "Install/Upgrade ingress-nginx (Service: ClusterIP)"
kubectl create namespace "$INGRESS_NS" --dry-run=client -o yaml | kubectl apply -f -

retry 5 3 helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
retry 5 3 helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  -n "$INGRESS_NS" \
  --set controller.service.type=ClusterIP

kubectl -n "$INGRESS_NS" rollout status deploy/ingress-nginx-controller --timeout=600s
kubectl -n "$INGRESS_NS" get svc "$INGRESS_SVC" -o wide
