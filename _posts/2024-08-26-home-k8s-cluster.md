---
layout: post
title: Creating Home Kubernetes Cluster Lab
tags: [macos, linux, k8s, ckad]
modified: 2025-02-23
---

From my earliest memories, I've always been fascinated by building my own Kubernetes cluster at home. Recently, I made it a reality by assembling a small lab using affordable PCs. In this post, I'll share the insights and lessons learned from my first attempt to set up a home Kubernetes cluster. Whether you're a seasoned admin or just starting out, I hope to provide valuable information on the hardware, software, and configurations that worked for me.

Throughout the article, you may come across snippets with additional output to illustrate key concepts and provide a deeper understanding of the installation process. These extra outputs are intended to help first-time users compare their results with mine, ensuring they can achieve similar success in setting up their own Kubernetes cluster.

## Hardware

- 3 x HP Elitedesk 800 G3 i5-6500T 2.5GHz 16GB 128GB SSD
- 3 x Network cable 50cm
- 1 x Network cable 5m
- 1 x Switch (5 ports is enough)
- 1 x Router (best with function to assign static IP) - I used my FritzBox router

## Software

- Kubernetes 1.31
- ssh, ssh-copy-id

## Before you start

- assemble your machines to together
  - 3 times network cables to switch
  - switch to router

## Start setup cluster

I assume you...

- install ubuntu 24.02

  ```sh
  $ lsb_release -a
  No LSB modules are available.
  Distributor ID: Ubuntu
  Description:    Ubuntu 24.04.2 LTS
  Release:        24.04
  Codename:       nobles
  ```

<div class="alert alert-info">
    <p><strong>Hey there! It's me from the future:</strong> In this tutorial, I'll be using Ubuntu as my primary operating system. While it's a great choice for beginners like you, if you're looking for a more stable and low-maintenance option, I'd recommend exploring the latest, stable Debian release.</p>
    <p>The reason behind my choice lies in Debian's excellent maintenance quality, its focus on server stability and performance. In the case of running a long-term Kubernetes cluster, I firmly believe that Debian is the better-suited distribution for such tasks.</p>
</div>

### Set up proper hostnames

At this point I assume you have all machines up and running connected to your local router so you
can access them.

in my case:

- Master

  ```sh
  sudo hostnamectl set-hostname cplane1
  ```

- Workers

  ```sh
  sudo hostnamectl set-hostname worker1 # worker 1
  ```

Add to `/ect/hosts`

```
192.168.178.200     cplane1
192.168.178.201     worker1
```

Test from each machine, example of reaching `cplane1` & `worker1`

```sh
maciej@cplane1:~$ ping worker1 -c3
PING worker1 (192.168.178.201) 56(84) bytes of data.
64 bytes from worker1 (192.168.178.201): icmp_seq=1 ttl=64 time=0.853 ms
64 bytes from worker1 (192.168.178.201): icmp_seq=2 ttl=64 time=0.586 ms
64 bytes from worker1 (192.168.178.201): icmp_seq=3 ttl=64 time=0.581 ms
```

```sh
maciej@worker1:~$ ping cplane1 -c3
PING cplane1 (192.168.178.200) 56(84) bytes of data.
64 bytes from cplane1 (192.168.178.200): icmp_seq=1 ttl=64 time=0.606 ms
64 bytes from cplane1 (192.168.178.200): icmp_seq=2 ttl=64 time=0.602 ms
64 bytes from cplane1 (192.168.178.200): icmp_seq=3 ttl=64 time=0.607 ms
```

### Enabling firewall

<div class="alert alert-warning">

<p>Important information, especially for those who want to create a home cluster:</p>

<ul>
<li>Learn to Kubernetes course (CKAD)</li>
<li>Or/and, if you're just beginning your journey with exploring Kubernetes (maybe Linux and command-line as well) for the first time.</li>
<li>Or/and start using it in your local network.</li>
</ul>

<p>I would strongly recommend disabling the firewall completely, unless you know what you're doing. Both for master and worker nodes.</p>
<p>However, I'm aware this is not a secure approach, and I do not recommend it for production clusters. If you're just starting out learning Kubernetes, focus on understanding this new technology rather than spending too much time finding the perfect installation by creating obstacles from the start.</p>
<p>Disabling the firewall can remove many problems with local networking and accessing cluster resources.</p>

</div>

- Master

  ```
  Protocol  Direction Port Range  Purpose Used By
  -----------------------------------------------
  TCP       Inbound   6443        Kubernetes API server All
  TCP       Inbound   2379-2380   etcd server client API  kube-apiserver, etcd
  TCP       Inbound   10250       Kubelet API Self, Control plane
  TCP       Inbound   10259       kube-scheduler  Self
  TCP       Inbound   10257       kube-controller-manager Self
  ```

  ```sh
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

- Workers

  ```sh
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

Enable kernel modules and add them to file for permament effect after reboot.

```sh
$ sudo modprobe overlay
$ sudo modprobe br_netfilter
$ cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
```

```sh
# add kernel parametes to load with k8s configuration
$ cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# load modules above
$ sudo sysctl --system
```

### Disable swap

To not have hicckups in our cluster it's recommended to disable the swap.

```sh
# disable with command
$ sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
# or comment the line manually
$ sudo vim /etc/fstab # disable /swap


$ sudo swapoff -a
$ free -m
               total        used        free      shared  buff/cache   available
Mem:           15783         261       15085           1         436       15255
Swap:              0           0           0
```

Now, repeat same for the other worker(s).

### Installing Containerd

```sh
$ sudo apt -y update && sudo apt -y upgrade
Hit:1 http://de.archive.ubuntu.com/ubuntu noble InRelease
Hit:2 http://de.archive.ubuntu.com/ubuntu noble-updates InRelease
Hit:3 http://de.archive.ubuntu.com/ubuntu noble-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease
Get:5 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  InRelease [1,189 B]
Err:5 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  InRelease
  The following signatures were invalid: EXPKEYSIG 234654DA9A296436 isv:kubernetes OBS Project <isv:kubernetes@build.opensuse.org>
Fetched 1,189 B in 1s (1,819 B/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
All packages are up to date.
W: An error occurred during the signature verification. The repository is not updated and the previous index files will be used. GPG error: https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  InRelease: The following signatures were invalid: EXPKEYSIG 234654DA9A296436 isv:kubernetes OBS Project <isv:kubernetes@build.opensuse.org>
W: Failed to fetch https://pkgs.k8s.io/core:/stable:/v1.31/deb/InRelease  The following signatures were invalid: EXPKEYSIG 234654DA9A296436 isv:kubernetes OBS Project <isv:kubernetes@build.opensuse.org>
W: Some index files failed to download. They have been ignored, or old ones used instead.
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.

# if having info about outdated gpg do following
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/containerd.gpg
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

# copy orginal configuration
sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.orig
sudo containerd config default > /etc/containerd/config.toml
-bash: /etc/containerd/config.toml: Permission denied

sudo su
root@worker1:/home/maciej# sudo containerd config default > /etc/containerd/config.toml
exit

# replace "SystemdCgroup = false" to "SystemdCgroup = true".
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
# or do it manually
sudo vim /etc/containerd/config.toml

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

$ sudo systemctl is-enabled containerd
```

### Install Kubernetes (kubeadm, kubelet, kubectl)

`kubeadm` requirements:

- RAM: min 2GB
- CPU: min 2
- disable swap

```sh
lsb_release -c
No LSB modules are available.
Codename:       noble

# add / refresh gpg key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

$ sudo apt update

$ sudo apt install kubelet kubeadm kubectl

# check installed versions
$ kubelet --version
Kubernetes v1.31.6

$ kubectl version
Client Version: v1.31.6
Kustomize Version: v5.4.2
The connection to the server localhost:8080 was refused - did you specify the right host or port?

$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"31", GitVersion:"v1.31.6", GitCommit:"6b3560758b37680cb713dfc71da03c04cadd657c", GitTreeState:"clean", BuildDate:"2025-02-12T21:31:09Z", GoVersion:"go1.22.12", Compiler:"gc", Platform:"linux/amd64"}

# Prevent kubernetes packages from being upgraded between versions
$ sudo apt-mark hold kubelet kubeadm kubectl
kubelet set on hold.
kubeadm set on hold.
kubectl set on hold.
```

```sh
# check is kubelet is running
sudo systemctl enable --now kubelet
```

## Installing CNI Plugin

Install Container Network Interface (CNI).

<div class="alert alert-info">
<p>When I for the first time Install Kubernetes I use flannel CNI. It was good, but it didn't work with the <code>NetworkPolicy</code>. Therefore, I could not accomplish some of the exercises I with it.</p>
<p>If you're setting up the Kubernetes cluster also for learning for the CKAD, I encourage you to use Calico&nbsp;CNI.</p>
</div>

- [Flannel][weblink-flannel-github] (simple, although `NetworkPolicy` is not working with it)

  If you want to use flannel, then you you have to install `flanneld` program

  ```sh
  sudo mkdir -p /opt/bin/
  sudo curl -fsSLo /opt/bin/flanneld https://github.com/flannel-io/flannel/releases/download/v0.25.5/flanneld-amd64

  sudo chmod +x /opt/bin/flanneld
  ```

- Calico (advance, recommended for K8s course)

  Setup will find later in the article.

## Installing kubernetes

Now setup `kubeadm init` and later finish with running CNI

```sh
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

# kubeadm and save the output text for later use (thanks to tee)
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

### configure CNI

- Flannel

  ```sh
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

- Calico
  configure NetworkManager

  ```sh
  $ kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
  namespace/tigera-operator created
  customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/bgpfilters.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/tiers.crd.projectcalico.org created
  customresourcedefinition.apiextensions.k8s.io/adminnetworkpolicies.policy.networking.k8s.io created
  customresourcedefinition.apiextensions.k8s.io/apiservers.operator.tigera.io created
  customresourcedefinition.apiextensions.k8s.io/imagesets.operator.tigera.io created
  customresourcedefinition.apiextensions.k8s.io/installations.operator.tigera.io created
  customresourcedefinition.apiextensions.k8s.io/tigerastatuses.operator.tigera.io created
  serviceaccount/tigera-operator created
  clusterrole.rbac.authorization.k8s.io/tigera-operator created
  clusterrolebinding.rbac.authorization.k8s.io/tigera-operator created
  deployment.apps/tigera-operator created

  # Install Calico by creating the necessary custom resource. For more information on
  # configuration options available in this manifest, see the installation reference.
  # https://docs.tigera.io/calico/latest/reference/installation/api

  # I used differnt cidr and need to be replaced
  # 10.244.0.0/16
  $ curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml >> custom-resources.yaml
  $ sed -i 's/192.168.0.0\/16/10.244.0.0\/16/g' custom-resources.yaml

  # apply modified config
  kubectl create -f custom-resources.yaml

  # check if working
  watch kubectl get pods -n calico-system
  Every 2.0s: kubectl get pods -n calico-system                                                                                                                                                                                cplane1: Tue Feb 25 15:43:40 2025

  NAME                                       READY   STATUS    RESTARTS   AGE
  calico-kube-controllers-56bf547c9f-nrn42   1/1     Running   0          40s
  calico-node-mf56l                          1/1     Running   0          41s
  calico-typha-6854bfcb4d-6bhh5              1/1     Running   0          41s
  csi-node-driver-mbqcl                      2/2     Running   0          40s

  # check taint
  $ kubectl describe nodes | grep -i taint
  Taints: node-role.kubernetes.io/control-plane:NoSchedule
  Taints: <none>

  # untained control plane
  kubectl taint nodes --all node-role.kubernetes.io/control-plane-
  node/cplane1 untainted

  # recheck taint
  $ kubectl describe nodes | grep -i taint
  Taints:             <none>
  Taints:             <none>

  # check nodes
  kubectl get nodes -o wide
  ```

  calicoctl

  ```sh
  curl -L https://github.com/projectcalico/calico/releases/download/v3.29.2/calicoctl-linux-amd64 -o calicoctl
  chmod +x ./calicoctl

  # move calicoctl to accessible on system path
  mv calicoctl /usr/local/bin/
  ```

---

As you may already noticed, we got some small errors with containerd images.

> W0818 20:50:23.203697 11745 checks.go:846] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.10" as the CRI sandbox image.

```sh
# open containerd config and update the pause image to desired version 3.10
vim /etc/containerd/config.toml

# after restart service to apply
systemctl restart containerd
```

### Installing useful tools

`kubens`, `kubectx`, `k9s`

Since we're running on Ubuntu 24, there is a more convenient way to install our software then via `/etc/apt/source.list.d/`

We will utilize `snap` ubuntu package manager.

```sh
sudo apt update
sudo apt install snapd

# installing programs
sudo snap install kubectx --classic # contains kubens
sudo snap install k9s
```

## End

Thank you your time and staying until the end. Hope you had as much fun reading as I had while preparing and documenting the steps in this article.

Stay save and until the next time.

### Resources

- <https://docs.docker.com/engine/install/ubuntu/>
- <https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/>
- <https://www.baeldung.com/ops/kubernetes-uninstall>
- <https://www.howtoforge.com/how-to-setup-kubernetes-cluster-with-kubeadm-on-ubuntu-22-04/>
- <https://www.linuxtechi.com/install-kubernetes-on-ubuntu-22-04/>
- <https://www.servethehome.com/introducing-project-tinyminimicro-home-lab-revolution/hp-elitedesk-705-g3-kubernetes/>

## FAQ

### Have you made a mistake and need reset?

After that you can do `kubeadm reset` and repeat seteps (recommend)

```sh
# delete calico
kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml
kubectk delete deploy tigera-operator -n tigera-operator

# reset cplane and workers
kubeadm reset

sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni
sudo apt-get autoremove

# Remove Related Files and Directories
sudo rm -rf ~/.kube
sudo rm -rf /etc/cni /etc/kubernetes rm -f /etc/apparmor.d/docker /etc/systemd/system/etcd*
sudo rm -rf /var/lib/dockershim /var/lib/etcd /var/lib/kubelet \
         /var/lib/etcd2/ /var/run/kubernetes

# Clear out the Firewall Tables and Rules (for some must be root user)
#
# flushing and deleting the filter table
sudo iptables -F && iptables -X
# lush and delete the NAT (Network Address Translation) table
sudo iptables -t nat -F && iptables -t nat -X
# flush and remove the chains and rules in the raw table
sudo iptables -t raw -F && iptables -t raw -X
# remove the chains and rules in the mangle table
sudo iptables -t mangle -F && iptables -t mangle -X

# optional: remove containerd
sudo apt-get remove containerd.io
sudo apt-get purge --auto-remove containerd

# if cplane continue to init
kubeadm init ... # and rest of flags
# if worker continue to join
sudo apt-get purge --auto-remove containerd
kubeadm join ... # and rest from kubeadm init
```

### After shutting down Nodes

```sh
maciej@cplane1:~$ kubectl get pv
E1225 20:37:45.232733    7857 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://192.168.178.200:6443/api?timeout=32s\": dial tcp 192.168.178.200:6443: connect: connection refused"
E1225 20:37:45.234160    7857 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://192.168.178.200:6443/api?timeout=32s\": dial tcp 192.168.178.200:6443: connect: connection refused"
E1225 20:37:45.235670    7857 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://192.168.178.200:6443/api?timeout=32s\": dial tcp 192.168.178.200:6443: connect: connection refused"
E1225 20:37:45.237148    7857 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://192.168.178.200:6443/api?timeout=32s\": dial tcp 192.168.178.200:6443: connect: connection refused"
E1225 20:37:45.238673    7857 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://192.168.178.200:6443/api?timeout=32s\": dial tcp 192.168.178.200:6443: connect: connection refused"
The connection to the server 192.168.178.200:6443 was refused - did you specify the right host or port?
```

Solution:

Just wait a moment until system will start and connect.

```sh
maciej@cplane1:~$ k get pv
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                     STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
vol1   1Gi        RWO            Retain           Bound    default/registry-claim0                  <unset>                          117d
vol2   200Mi      RWO            Retain           Bound    default/nginx-claim0                     <unset>                          117d
```

[weblink-flannel-github]: https://github.com/flannel-io/flannel
