#!/usr/bin/env bash
set -euo pipefail
source ci/scripts/lib.sh

need_var TF_ROOT
need_var TF_STATE_BUCKET
need_var TF_STATE_KEY
need_var AWS_REGION
need_var CI_PROJECT_DIR

log "Terraform init (remote backend) + read outputs"
cd "$TF_ROOT"

terraform init -reconfigure -input=false \
  -backend-config="bucket=${TF_STATE_BUCKET}" \
  -backend-config="key=${TF_STATE_KEY}" \
  -backend-config="region=${AWS_REGION}"

AWS_REGION_OUT="$(terraform output -raw region 2>/dev/null || echo "${AWS_REGION}")"
EKS_CLUSTER_NAME="$(terraform output -raw eks_cluster_name 2>/dev/null || true)"
NLB_TG_ARN="$(terraform output -raw ingress_nlb_target_group_arn 2>/dev/null || true)"
AWS_LBC_ROLE_ARN="$(terraform output -raw aws_lbc_role_arn 2>/dev/null || true)"

[[ -n "$EKS_CLUSTER_NAME" ]] || { err "eks_cluster_name output is empty"; exit 1; }
[[ -n "$NLB_TG_ARN" ]]      || { err "ingress_nlb_target_group_arn output is empty"; exit 1; }
[[ -n "$AWS_LBC_ROLE_ARN" ]]|| { err "aws_lbc_role_arn output is empty"; exit 1; }

cat > "$CI_PROJECT_DIR/outputs.env" <<EOF
AWS_REGION=${AWS_REGION_OUT}
EKS_CLUSTER_NAME=${EKS_CLUSTER_NAME}
NLB_TG_ARN=${NLB_TG_ARN}
AWS_LBC_ROLE_ARN=${AWS_LBC_ROLE_ARN}
EOF

log "outputs.env"
cat "$CI_PROJECT_DIR/outputs.env"
