#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="cilium-lab"
CILIUM_VERSION="1.20.1"
KIND_CONFIG="$(dirname "$0")/kind-cilium.yaml"

command -v kind >/dev/null 2>&1 || { echo "kind is not installed. Install it first." >&2; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl is not installed. Install it first." >&2; exit 1; }
command -v cilium >/dev/null 2>&1 || { echo "cilium CLI is not installed. Run install-cilium-cli-macos.sh first." >&2; exit 1; }

if kind get clusters 2>/dev/null | grep -qx "${CLUSTER_NAME}"; then
  echo "Kind cluster '${CLUSTER_NAME}' already exists, skipping creation."
else
  echo "Creating kind cluster '${CLUSTER_NAME}' (no kube-proxy, no default CNI)..."
  kind create cluster --name "${CLUSTER_NAME}" --config "${KIND_CONFIG}"
fi

kubectl config use-context "kind-${CLUSTER_NAME}"

echo "Installing Cilium ${CILIUM_VERSION} with kube-proxy replacement..."
cilium install \
  --version "${CILIUM_VERSION}" \
  --set kubeProxyReplacement=true \
  --set routingMode=tunnel \
  --set tunnelProtocol=vxlan \
  --set ipam.mode=cluster-pool \
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true \
  --set cluster.name=`${CLUSTER_NAME}'

echo "Waiting for Cilium to become ready..."
cilium status --wait

echo "Enabling Hubble..."
cilium hubble enable --ui

echo "Cluster '${CLUSTER_NAME}' is ready with Cilium installed."
cilium status
