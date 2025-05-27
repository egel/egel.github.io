---
layout: post
title: Creating Home Kubernetes Cluster Lab
tags: [macos, linux, k8s]
---

-   Github reference project with helper files: <https://github.com/egel/k8s-home-cluster>

https://www.servethehome.com/introducing-project-tinyminimicro-home-lab-revolution/hp-elitedesk-705-g3-kubernetes/

## Hardware

-   3 x HP Elitedesk 800 G3 i5-6500T 2.5GHz 16GB 128GB SSD
-   3 x Network cable 50cm
-   1 x Network cable 5m
-   1 x switch
-   1 x router (best with function to assign static IP)

-   <https://docs.docker.com/engine/install/ubuntu/>

-   Following <https://www.howtoforge.com/how-to-setup-kubernetes-cluster-with-kubeadm-on-ubuntu-22-04/>
-   Follow when installing against real domains/clusters https://www.linuxtechi.com/install-kubernetes-on-ubuntu-22-04/

## Software

-   Ansible ?
-   Kubernetes 1.31 ?
-   ssh, ssh-copy-id

## before we start

-   connect your machines to together
    -   4 times network cables
    -   switch

---

### Set up proper hostnames

Master

```bash
sudo hostnamectl set-hostname cplane1
```

Workers

```bash
sudo hostnamectl set-hostname worker1 # worker 1

sudo hostnamectl set-hostname worker2 # worker 2
```

Add to /ect/hosts

```
192.168.178.200     cplane1
192.168.178.201     worker1
192.168.178.202     worker2
```

Test from each, example from `cplane1` to `worker1`

```
maciej@cplane1:~$ ping worker1 -c3
PING worker1 (192.168.178.201) 56(84) bytes of data.
64 bytes from worker1 (192.168.178.201): icmp_seq=1 ttl=64 time=0.853 ms
64 bytes from worker1 (192.168.178.201): icmp_seq=2 ttl=64 time=0.586 ms
64 bytes from worker1 (192.168.178.201): icmp_seq=3 ttl=64 time=0.581 ms
```

```
maciej@worker1:~$ ping cplane1 -c3
PING cplane1 (192.168.178.200) 56(84) bytes of data.
64 bytes from cplane1 (192.168.178.200): icmp_seq=1 ttl=64 time=0.606 ms
64 bytes from cplane1 (192.168.178.200): icmp_seq=2 ttl=64 time=0.602 ms
64 bytes from cplane1 (192.168.178.200): icmp_seq=3 ttl=64 time=0.607 ms
```

### Enabling firewall

Master

**IMPORTANT INFO:**

If you just want to:

-   learn k8s
-   or/and for example you just begin your journey with exploring k8s (maybe Linux, and command line as well) for the first times
-   or/and using them in your local network

I would recommend to **disable the firewall completely, unless you know what you do**. Both for
master and for worker nodes.
I am aware this is not secure approach, but we are just start learning now and we should not put too many obstacles in the first shot.
Disabling the firewall can remove many problems with local networking and accessing to cluster resources.

```
Protocol  Direction Port Range  Purpose Used By
-----------------------------------------------
TCP       Inbound   6443        Kubernetes API server All
TCP       Inbound   2379-2380   etcd server client API  kube-apiserver, etcd
TCP       Inbound   10250       Kubelet API Self, Control plane
TCP       Inbound   10259       kube-scheduler  Self
TCP       Inbound   10257       kube-controller-manager Self
```

```bash
sudo ufw allow "OpenSSH"
sudo ufw enable

# Test
sudo ufw status

sudo ufw allow 6443/tcp
sudo ufw allow 2379:2380/tcp
sudo ufw allow 10250/tcp
sudo ufw allow 10259/tcp
sudo ufw allow 10257/tcp

# Test
$ sudo ufw status
[sudo] password for maciej:
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
6443/tcp                   ALLOW       Anywhere
2379:2380/tcp              ALLOW       Anywhere
10250/tcp                  ALLOW       Anywhere
10259/tcp                  ALLOW       Anywhere
10257/tcp                  ALLOW       Anywhere
OpenSSH (v6)               ALLOW       Anywhere (v6)
6443/tcp (v6)              ALLOW       Anywhere (v6)
2379:2380/tcp (v6)         ALLOW       Anywhere (v6)
10250/tcp (v6)             ALLOW       Anywhere (v6)
10259/tcp (v6)             ALLOW       Anywhere (v6)
10257/tcp (v6)             ALLOW       Anywhere (v6)
```

Workers

```bash
sudo ufw allow "OpenSSH"
sudo ufw enable

sudo ufw allow 10250/tcp
sudo ufw allow 30000:32767/tcp

# Test
$ sudo ufw status
[sudo] password for maciej:
Status: active

To                         Action      From
--                         ------      ----
10250/tcp                  ALLOW       Anywhere
30000:32767/tcp            ALLOW       Anywhere
OpenSSH                    ALLOW       Anywhere
10250/tcp (v6)             ALLOW       Anywhere (v6)
30000:32767/tcp (v6)       ALLOW       Anywhere (v6)
OpenSSH (v6)               ALLOW       Anywhere (v6)
```

### Enable kernel modules & disable swap

Enable on all modulesl

```bash
$ sudo modprobe overlay
$ sudo modprobe br_netfilter
$ cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
overlay
br_netfilter

#
$ cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

$ sudo sysctl --system

$ sudo vim /etc/fstab # disable /swap

$sudo swapoff -a
$free -m
               total        used        free      shared  buff/cache   available
Mem:           15783         261       15085           1         436       15255
Swap:              0           0           0
```

Repeat for other worker

```bash

```

### Installing Containerd

```bash
sudo apt -y update && sudo apt -y upgrade

# Prepare for new repos
sudo apt -y install apt-transport-https ca-certificates software-properties-common curl gnupg

# Add Docker’s official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Use the following command to set up the repository:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt -y update

sudo apt install containerd.io # docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin

# stop containers
sudo systemctl stop containerd

# copy configuration
sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.orig
sudo containerd config default > /etc/containerd/config.toml
-bash: /etc/containerd/config.toml: Permission denied

sudo su
root@worker1:/home/maciej# sudo containerd config default > /etc/containerd/config.toml
exit

sudo vim /etc/containerd/config.toml

# "SystemdCgroup = false" to "SystemdCgroup = true".

# start
sudo systemctl start containerd

$ sudo systemctl status containerd
● containerd.service - containerd container runtime
     Loaded: loaded (/lib/systemd/system/containerd.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2023-04-19 23:05:59 UTC; 1min 12s ago
       Docs: https://containerd.io
    Process: 2285 ExecStartPre=/sbin/modprobe overlay (code=exited, status=0/SUCCESS)
   Main PID: 2286 (containerd)
      Tasks: 10
     Memory: 12.7M
        CPU: 248ms
     CGroup: /system.slice/containerd.service
             └─2286 /usr/bin/containerd

Apr 19 23:05:59 worker1 containerd[2286]: time="2023-04-19T23:05:59.574566257Z" level=info msg=serving... address=/run/container>
Apr 19 23:05:59 worker1 containerd[2286]: time="2023-04-19T23:05:59.574626153Z" level=info msg=serving... address=/run/container>
Apr 19 23:05:59 worker1 containerd[2286]: time="2023-04-19T23:05:59.574685614Z" level=info msg="containerd successfully booted i>
Apr 19 23:05:59 worker1 systemd[1]: Started containerd container runtime.
Apr 19 23:05:59 worker1 containerd[2286]: time="2023-04-19T23:05:59.574660458Z" level=info msg="Start subscribing containerd eve>
Apr 19 23:05:59 worker1 containerd[2286]: time="2023-04-19T23:05:59.576694989Z" level=info msg="Start recovering state"
Apr 19 23:05:59 worker1 containerd[2286]: time="2023-04-19T23:05:59.576767152Z" level=info msg="Start event monitor"
Apr 19 23:05:59 worker1 containerd[2286]: time="2023-04-19T23:05:59.576792721Z" level=info msg="Start snapshots syncer"
Apr 19 23:05:59 worker1 containerd[2286]: time="2023-04-19T23:05:59.576807855Z" level=info msg="Start cni network conf syncer fo>
Apr 19 23:05:59 worker1 containerd[2286]: time="2023-04-19T23:05:59.576816067Z" level=info msg="Start streaming server"


sudo systemctl is-enabled containerd
sudo systemctl status containerd
```

### Install Kubernetes (kubeadm kubelet kubectl)

Kubeadm:

-   min 2GB <= RAM, min 2 <= CPU
-   disable swap

```bash
$ lsb_release -c
Codename:	jammy

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update

sudo apt install kubelet kubeadm kubectl

# check installed versions
$ kubelet --version
$ kubectl version
$ kubeadm version

# Prevent kubernetes packages from being upgraded between versions
$ sudo apt-mark hold kubelet kubeadm kubectl
kubelet set on hold.
kubeadm set on hold.
kubectl set on hold.
```

```bash
# check is kubelet is running
sudo systemctl enable --now kubelet
```

## CNI - Flannel

Install Container Network Interface (CNI). I simply use [flannel](https://github.com/flannel-io/flannel), but you can use other. The list you can
find here ()

```bash
sudo mkdir -p /opt/bin/
sudo curl -fsSLo /opt/bin/flanneld https://github.com/flannel-io/flannel/releases/download/v0.25.5/flanneld-amd64

sudo chmod +x /opt/bin/flanneld
```

Now setup kubeadm init and later finish with running CNI

```bash
$ kubeadm init
[init] Using Kubernetes version: v1.27.1
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR IsPrivilegedUser]: user is not running as root
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher

# become a root
maciej@cplane1:~$ sudo su

# pull images before
root@cplane1:/home/root# kubeadm config images pull
[config/images] Pulled registry.k8s.io/kube-apiserver:v1.31.0
[config/images] Pulled registry.k8s.io/kube-controller-manager:v1.31.0
[config/images] Pulled registry.k8s.io/kube-scheduler:v1.31.0
[config/images] Pulled registry.k8s.io/kube-proxy:v1.31.0
[config/images] Pulled registry.k8s.io/coredns/coredns:v1.11.1
[config/images] Pulled registry.k8s.io/pause:3.10
[config/images] Pulled registry.k8s.io/etcd:3.5.15-0

# kubeadm and save the output for later use (with tee)
root@cplane1:/home/root# kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.178.200 --cri-socket=unix:///run/containerd/containerd.sock | tee kubeadm_init_store.txt
[init] Using Kubernetes version: v1.31.0
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action beforehand using 'kubeadm config images pull'
W0818 20:50:23.203697   11745 checks.go:846] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.10" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [cplane1 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.178.200]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [cplane1 localhost] and IPs [192.168.178.200 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [cplane1 localhost] and IPs [192.168.178.200 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "super-admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests"
[kubelet-check] Waiting for a healthy kubelet at http://127.0.0.1:10248/healthz. This can take up to 4m0s
[kubelet-check] The kubelet is healthy after 1.001949593s
[api-check] Waiting for a healthy API server. This can take up to 4m0s
[api-check] The API server is healthy after 4.002920718s
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node cplane1 as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node cplane1 as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: 8o34w9.jyhtv2av6l2ozv5d
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.178.200:6443 --token 8o34w9.jyhtv2av6l2ozv5d \
        --discovery-token-ca-cert-hash sha256:ab1a9a94e63fd993ba5b4959af0cea371cbb2339637bc1662de5f8121803bcbd
```

configure flannel

```bash
root@cplane1:/home/root# cat <<EOF | tee /run/flannel/subnet.env
FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.0.0/16
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true
EOF

root@cplane1:/home/root# kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
namespace/kube-flannel created
serviceaccount/flannel created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created
```

---

As you may already noticed, we got some small errors with containerd images.

> W0818 20:50:23.203697 11745 checks.go:846] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.10" as the CRI sandbox image.

```bash
# open containerd config and update the pause image to desired version 3.10
vim /etc/containerd/config.toml

# after restart service to apply
systemctl restart containerd

# after that you can do kubeadm reset and repeat seteps (recommend)
kubeadm reset

kubeadm init ... # and rest of flags
```

### Installing useful tools

`kubens`, `kubectx`, `k9s`

Since we're running on Ubuntu 22, there is a more convenient way to install our software then via `/etc/apt/source.list.d/`

We will utilize `snap` ubuntu package manager.

```
sudo apt update
sudo apt install snapd

# installing programs
sudo snap install kubectx --classic # contains kubens
sudo snap install k9s
```

Thank you your time and staying until the end of part 1. Hope you had as much fun as I had while preparing and documenting all steps in this article.

Stay save and until the next time.

[weblink-imagemagic]: https://imagemagick.org/
[weblink-libheif-macos]: https://www.libde265.org/
[weblink-libheif-alternative]: https://github.com/strukturag/libheif
