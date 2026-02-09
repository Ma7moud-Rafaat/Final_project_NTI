#!/usr/bin/env bash
set -euo pipefail
source scripts/lib.sh

need_var DOMAIN_BASE
need_var INGRESS_NS
need_var INGRESS_SVC
need_var NLB_TG_ARN
kube_setup

log "Apply TargetGroupBinding -> ingress-nginx-controller:80"
cat > /tmp/ingress-nginx-tgb.yaml <<'EOF'
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: ingress-nginx-tgb
  namespace: ${INGRESS_NS}
spec:
  serviceRef:
    name: ${INGRESS_SVC}
    port: 80
  targetGroupARN: ${NLB_TG_ARN}
  targetType: ip
EOF

envsubst '${INGRESS_NS} ${INGRESS_SVC} ${NLB_TG_ARN}' < /tmp/ingress-nginx-tgb.yaml | kubectl apply -f -
kubectl -n "$INGRESS_NS" get targetgroupbinding ingress-nginx-tgb

log "Apply Ingress rules (ArgoCD / Vault / Nexus)"

cat > /tmp/argocd-ing.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-ing
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/rewrite-target: "/\$2"
spec:
  ingressClassName: nginx
  rules:
  - host: argocd.${DOMAIN_BASE}
    http:
      paths:
      - path: /argocd(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: argocd-server
            port:
              number: 443
EOF

cat > /tmp/argocd-rootpaths-ing.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-rootpaths-ing
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/rewrite-target: "/\$2"
spec:
  ingressClassName: nginx
  rules:
  - host: argocd.${DOMAIN_BASE}
    http:
      paths:
      - path: /api(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: argocd-server
            port:
              number: 443
      - path: /auth(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: argocd-server
            port:
              number: 443
      - path: /assets(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: argocd-server
            port:
              number: 443
EOF

cat > /tmp/vault-ing.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: vault-ing
  namespace: vault
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    nginx.ingress.kubernetes.io/rewrite-target: "/\$2"
spec:
  ingressClassName: nginx
  rules:
  - host: vault.${DOMAIN_BASE}
    http:
      paths:
      - path: /vault(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: vault
            port:
              number: 8200
EOF

cat > /tmp/vault-ui-ing.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: vault-ui-ing
  namespace: vault
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    nginx.ingress.kubernetes.io/rewrite-target: "/ui/\$2"
spec:
  ingressClassName: nginx
  rules:
  - host: vault.${DOMAIN_BASE}
    http:
      paths:
      - path: /ui(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: vault
            port:
              number: 8200
EOF

cat > /tmp/vault-v1-ing.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: vault-v1-ing
  namespace: vault
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    nginx.ingress.kubernetes.io/rewrite-target: "/v1/\$2"
spec:
  ingressClassName: nginx
  rules:
  - host: vault.${DOMAIN_BASE}
    http:
      paths:
      - path: /v1(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: vault
            port:
              number: 8200
EOF

cat > /tmp/nexus-ing.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nexus-ing
  namespace: nexus
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    nginx.ingress.kubernetes.io/rewrite-target: "/\$2"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
spec:
  ingressClassName: nginx
  rules:
  - host: nexus.${DOMAIN_BASE}
    http:
      paths:
      - path: /nexus(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: nexus-nexus-repository-manager
            port:
              number: 8081
EOF

kubectl apply -f /tmp/argocd-ing.yaml
kubectl apply -f /tmp/argocd-rootpaths-ing.yaml
kubectl apply -f /tmp/vault-ing.yaml
kubectl apply -f /tmp/vault-ui-ing.yaml
kubectl apply -f /tmp/vault-v1-ing.yaml
kubectl apply -f /tmp/nexus-ing.yaml

kubectl get ingress -A -o wide
