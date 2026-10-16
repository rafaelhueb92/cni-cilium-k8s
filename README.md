<div align="center">

# 🐝 Cilium + Kind Kubernetes Lab

![Cilium](https://img.shields.io/badge/Cilium-2.0-blue?style=for-the-badge&logo=cilium&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

A local Kubernetes cluster 🎛️ with **Cilium** as the CNI 🐝 — using **kind** to spin up a multi-node cluster with **kube-proxy replacement** and **Hubble** for observability 👁️.

</div>

---

## ✨ Features

- 🚀 **kind** multi-node cluster (1 control-plane + 4 workers)
- 🐝 **Cilium** as the CNI — with full **kube-proxy replacement** (`kubeProxyMode: none`)
- 🛰️ **Hubble** enabled with **relay** + **UI** for real-time service-map visualization
- 🌐 **Cilium Mesh** via VXLAN tunnel routing
- 📦 IPAM via **cluster-pool** mode
- 🧩 Minimal, reproducible scripts for macOS

## 🗂️ What's Inside

| File | Description |
|------|-------------|
| `kind-cilium.yaml` | Kind cluster config (no default CNI, no kube-proxy) |
| `init-cluster.sh` | Creates the cluster & installs Cilium + Hubble in one go |
| `install-cilium-cli-macos.sh` | Installs the Cilium CLI (macOS, arm64/amd64) |
| `install-hubble-cli-macos.sh` | Installs the Hubble CLI (macOS, arm64/amd64) |

## 🧑‍💻 Prerequisites

- [Docker](https://www.docker.com/) ✅
- [kind](https://kind.sigs.k8s.io/) ✅
- [kubectl](https://kubernetes.io/docs/tasks/tools/) ✅
- macOS (arm64 or amd64) 🍎

## 🚀 Getting Started

### 1️⃣ Install the Cilium CLI

```bash
./install-cilium-cli-macos.sh
```

### 2️⃣ Install the Hubble CLI

```bash
./install-hubble-cli-macos.sh
```

### 3️⃣ Create the cluster & install Cilium

```bash
./init-cluster.sh
```

This will:

1. Create the kind cluster `cilium-lab` 🎛️
2. Install Cilium `1.20.1` with kube-proxy replacement 🐝
3. Enable Hubble **relay** + **UI** 👁️
4. Wait for everything to be ready ⏳

### 🎉 Done!

Verify your cluster:

```bash
cilium status
```

Open the Hubble UI 🌐:

```bash
cilium hubble ui
```

You should see:

- ✅ Cluster: `cilium-lab`
- ✅ Cilium version: `1.20.1`
- ✅ KubeProxyReplacement: enabled
- ✅ Hubble: relay + UI enabled

## ⚙️ Cluster Configuration

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker   # x4
networking:
  disableDefaultCNI: true   # Cilium is the only CNI
  kubeProxyMode: "none"     # full kube-proxy replacement
```

## 🧹 Cleanup

Delete the cluster when you're done:

```bash
kind delete cluster --name cilium-lab
```


