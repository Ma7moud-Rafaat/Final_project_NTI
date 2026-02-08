#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\n\033[1;34m[INFO]\033[0m  $*"; }
warn() { echo -e "\n\033[1;33m[WARN]\033[0m  $*"; }
err()  { echo -e "\n\033[1;31m[ERROR]\033[0m $*" >&2; }

# Print the line/command that failed (super useful in CI logs)
on_error() {
  local exit_code=$?
  err "Failed at line ${BASH_LINENO[0]}: ${BASH_COMMAND}"
  exit "$exit_code"
}
trap on_error ERR

need_var() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    err "Missing required env var: ${name}"
    exit 1
  fi
}

need_bin() {
  local b="$1"
  command -v "$b" >/dev/null 2>&1 || { err "Missing required binary: $b"; exit 1; }
}

retry() {
  local tries="${1:-5}"; shift
  local delay="${1:-3}"; shift
  local n=1

  until "$@"; do
    local rc=$?
    if (( n >= tries )); then
      err "Command failed after ${tries} tries (rc=${rc}): $*"
      return "$rc"
    fi
    warn "Retry ${n}/${tries} failed (rc=${rc}). Sleeping ${delay}s... ($*)"
    sleep "${delay}"
    n=$((n+1))
  done
}

kube_setup() {
  need_var AWS_REGION
  need_var EKS_CLUSTER_NAME
  need_var KUBECONFIG

  need_bin aws
  need_bin kubectl

  log "Configure kubeconfig"
  aws eks update-kubeconfig \
    --region "$AWS_REGION" \
    --name "$EKS_CLUSTER_NAME" \
    --kubeconfig "$KUBECONFIG" >/dev/null

  # Quick connectivity check
  kubectl --kubeconfig "$KUBECONFIG" get ns >/dev/null
  log "Kubernetes connectivity OK"
}
