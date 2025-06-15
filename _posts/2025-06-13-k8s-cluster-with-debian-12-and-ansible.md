---
layout: post
title: Kubernetes cluster with Debian 12 and Ansible
tags: [macos, linux, k8s, docker, ansible, ckad]
# modified: 2025-02-23
---

This is my 2nd attempt to setup kubernetes cluster. In [previous version][post-home-k8s-cluster], I used only 2 nodes with Ubuntu 24.02 image. This time I decided to use 3 nodes and each will be equipped with Debian 12.11 Bookworm.

I also enhance the article, comparing to [previous version][post-home-k8s-cluster] with richer descriptions. This time we will install [Calico CNI][weblink-calido-docs] as it's much more powerful and better to prepare for your CKAD exam.

Moreover, I took some learnings from the past and as always wanted to use [Ansible before although never had time to do so. Now was perfect opportunity to do so. Therefore I will also support myself with some playbooks I wrote for this purpose to speedup setting up the cluster nodes. If you are not familiar with Ansible, shortening it in once sentence _Ansible is software that help automating tasks execution - for example executing commands on remote desktops_. If ansible is new to you I would warmly encourage you to see [the offical Ansible docs][weblink-ansible-docs] and try it out.

## Project's Topology

Here in sample picture is how our local home topology might look like:

![Network topology](/assets/posts/k8s-cluster-with-debian-and-ansible/network-topology.png)

In here is how our home cluster topology might look like:

![K8s topology](/assets/posts/k8s-cluster-with-debian-and-ansible/k8s-topology.png)

### Hardware

Similar to [previous version][post-home-k8s-cluster].

- 3 x HP Elitedesk 800 G3 i5-6500T 2.5GHz 16GB 128GB SSD
- 3 x Network cable 50cm
- 1 x Network cable 5m
- 1 x Switch (5 ports is enough)
- 1 x Router (best with function to assign static IP) - I used my FritzBox router

### Software

Depends how much in future you read this article, so the versions may changed. At the time of writing I used the latest version of:

- Node's OS: [Debian 12.11 Bookworm][weblink-debian-download]
- Kubernetes: `v1.33.1`
- CNI Plugin: `Calico v3.29.2`
- Container runtime: `containerd`
- Ansible `v2.18.5`

## Before you start

Assemble your Nodes to together:

- 3 times network cables to switch
- switch to router

### Master node requirements (cplane1)

**Hardware**:

- CPU: minimum 2 CPU
- RAM: at least 2GB (4GB or more preferred)
- Disc: min space 20GB (the more the better)

**Software**:

- `kubeadm`
- `kubectl`
- `kubelet`
- Calico CNI
- containerd

### Worker nodes requirements (worker1, worker2)

**Hardware**:

- CPU: minimum 1 CPU
- RAM: at least 512MB (2GB or more preferred)
- Disc: min space 20GB (more preferred)

**Software**:

- `kubelet`
- `kubectl` (optional)
- Calico CNI
- containerd

## Start setup cluster

I assume you...

- have installed Debian 12 Bookworm on your Nodes.

    ```sh
    $ lsb_release -a
    No LSB modules are available.
    Distributor ID: Debian
    Description:    Debian GNU/Linux 12 (bookworm)
    Release:        12
    Codename:       bookworm
    ```

- each node have user with sudo privileges
- each node have enabled ssh connection
- each node have `source.list` configured and can do `apt update` successfully
- each node and your main laptop have ansible and related software installed.

If this is still not done yet, no worry. See my other article about [Complete guide to install and configure Debian 12][post-install-and-configure-debian12] that might help you reach this point quicker.

**macOS**

```sh
brew install ansible sshpass
```

**Nodes (with Debian)**

```sh
apt install ansible sshpass -y
```

Two words about my Ansible configuration. Here is very primitive configuration within `inventory.yaml` file. It's intentionally very simple (even with plain text pass(just for simplicity of its usage), so please adjust the given variable to your needs.

If you prefer not write down passwords for each node, remove them and use [Ansible flags][weblink-ansible-cli-docs] `-k` (or [`--`](https://docs.ansible.com/ansible/latest/cli/ansible.html#cmdoption-ansible-k)) and `-K` (or [`--ask-become-pass`](https://docs.ansible.com/ansible/latest/cli/ansible.html#cmdoption-ansible-K)) at the end. It will ask you for user password and user sudo password before each execution.

```yaml
# inventory.yaml

# Master nodes
cplanes:
    hosts:
        cplane1:
            ansible_host: 192.168.178.200
    vars:
        ansible_user: maciej
        ansible_post: 22
        ansible_password: MY_PASSWORD
        ansible_sudo_pass: MY_PASSWORD

# Worker nodes
workers:
    hosts:
        worker1:
            ansible_host: 192.168.178.201
        worker2:
            ansible_host: 192.168.178.202
    # Global variables
    vars:
        ansible_user: maciej
        ansible_post: 22
        ansible_password: MY_PASSWORD
        ansible_sudo_pass: MY_PASSWORD
```

### Set up proper hostnames and timezone

At this point I assume you have all machines up and running connected to your local router so you
can access them.

in my case:

- Master

    ```sh
    sudo hostnamectl set-hostname cplane1
    sudo timedatectl set-timezone Europe/Berlin
    ```

- Workers

    ```sh
    # worker 1
    sudo hostnamectl set-hostname worker1
    sudo timedatectl set-timezone Europe/Berlin

    # worker 2
    sudo hostnamectl set-hostname worker2
    sudo timedatectl set-timezone Europe/Berlin
    ```

Add to `/ect/hosts`

```
192.168.178.200     cplane1
192.168.178.201     worker1
192.168.178.202     worker2
```

Test from each machine, example of reaching `cplane1`, `worker1` & `worker2`.

```yaml
# debian-ping-nodes.yaml
---
- name: This playbook will test ping all cluster nodes
  hosts: mynodes
  tasks:
      - name: Ping each node
        become: true
        register: out
        ansible.builtin.shell: |
            ping cplane1 -c3
            ping worker1 -c3
            ping worker2 -c3
      - debug: var=out.stdout_lines
```

Let's play to check successful connections

```sh
ansible-playbook -i inventory.yaml debian-ping-nodes.yaml
```

### Enable kernel modules & disable swap

Enable kernel modules and add them to file for permanent effect after reboot.

```yaml
# debian_enable_kernel_modules.yaml
---
- name: This playbook for enabling kernel modules on Debian 12 Bookworm
  hosts:
      - cplanes
      - workers
  tasks:
      - name: Check if target OS is Debian
        fail:
            msg: Stopped execution as the target OS is not Debian
        when: ansible_facts['os_family'] != "Debian"

      - name: Enable kernel modules
        become: true
        register: out
        ansible.builtin.shell: |
            sudo modprobe overlay
            sudo modprobe br_netfilter

            # persist modules after restart
            cat <<'EOF' | sudo tee /etc/modules-load.d/k8s.conf
            overlay
            br_netfilter
            EOF

            # add kernel parameters to load with k8s configuration
            cat <<'EOF' | sudo tee /etc/sysctl.d/k8s.conf
            net.bridge.bridge-nf-call-iptables  = 1
            net.bridge.bridge-nf-call-ip6tables = 1
            net.ipv4.ip_forward                 = 1
            EOF

            # load modules above
            sudo sysctl --system

      - name: Show results
        debug: var=out.stdout_lines
```

```sh
ansible-playbook -i inventory.yaml
```

### Disable swap

To not have hiccups in our cluster it's recommended to disable the swap .

```yaml
---
- name: This playbook disable swap on Debian 12 Bookworm
  hosts:
      - cplanes
      - workers
  tasks:
      - name: Check if target OS is Debian
        fail:
            msg: Stopped execution as the target OS is not Debian
        when: ansible_facts['os_family'] != "Debian"

      - name: Disable swap
        become: true
        ansible.builtin.shell: |
            # disable swap in f
            sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
            # release swap
            sudo swapoff -a

            # update grub configuration
            sudo update-grub

            # Essential to make swap modifications that impact boot process
            sudo update-initramfs -u

      - name: Test if swap has been released
        become: true
        register: out
        ansible.builtin.shell: |
            free -m

      - debug: var=out.stdout_lines
```

And play it

```sh
ansible-playbook -i inventory.yaml debian_disable_swap.yaml
```

### Installing Docker and Containerd

I am installing `docker` and `containerd` as some tasks for CKAD exam require to preform some actions to build, push or save images them to specific files.

Let's run this ansible command

```yaml
# debian_install_docker_and_containerd.yaml
---
- name: This playbook update install docker and containerd on Debian 12 Bookworm
  hosts:
      - cplanes
      - workers
  tasks:
      - name: Update and upgrade Debian packages
        become: true
        ansible.builtin.shell: |
            apt -y update
            apt -y upgrade
      # source: https://docs.docker.com/engine/install/debian/
      - name: Add Docker's official GPG key and add repository to sourcelist
        become: true
        ansible.builtin.shell: |
            sudo apt -y install ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc

            # Add the repository to Apt sources:
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt update -y
      - name: Install docker and containerd
        become: true
        ansible.builtin.shell: |
            sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      - name: Test docker installation
        become: true
        register: out
        ansible.builtin.shell: |
            sudo docker run hello-world
      - debug: var=out.stdout_lines
```

```sh
ansible-playbook -i inventory.yaml debian_install_docker_and_containerd.yaml
```

If all goes well we should see the logs of successful test the docker `hello-world` image and see successful logs from ansible, something like this:

```
PLAY RECAP *********************************************************************************************************
cplane1                    : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
worker1                    : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
worker2                    : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### Configure containerd

Now, if we already have `conainerd` installed on all our nodes let's configure them.

```yaml
---
- name: This playbook to configure containerd on Debian 12 Bookworm
  hosts:
      - cplanes
      - workers
  tasks:
      - name: Check if target OS is Debian
        fail:
            msg: Stopped execution as the target OS is not Debian
        when: ansible_facts['os_family'] != "Debian"

      - name: Check if containerd exist
        stat:
            path: /usr/bin/containerd
        register: program_exist

      - name: Fail if conatinerd does not exist
        fail:
            msg: Please install conatinerd before
        when: not program_exist.stat.exists

      - name: Update and upgrade Debian packages
        become: true
        ansible.builtin.shell: |
            apt -y update
            apt -y upgrade

      - name: Configure containerd
        become: true
        ansible.builtin.shell: |
            # stop containers
            sudo systemctl stop containerd

            # copy original configuration
            sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.orig
            sudo containerd config default > /etc/containerd/config.toml

            # replace "SystemdCgroup = false" to "SystemdCgroup = true".
            sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

            # replace 'sandbox_image = "registry.k8s.io/pause:3.8" with newer 3.10
            sudo sed -i 's/sandbox_image \= "registry.k8s.io\/pause:3.8"/sandbox_image \= "registry.k8s.io\/pause:3.10"/g' /etc/containerd/config.toml

            # start
            sudo systemctl start containerd

      - name: Test the status of containerd
        become: true
        register: out
        ansible.builtin.shell: |
            sudo systemctl is-enabled containerd
      - name: Show results
        debug: var=out.stdout_lines
```

```sh
ansible-playbook -i inventory.yaml debian_configure_containerd.yaml
```

### Install Kubernetes: kubelet, kubectl and kubeadm

- `kubctl` - it's optional to install it on the worker nodes, but we will do it to spare ourself to one ansible install command
- `kubeadm` - for nodes only used to join

```yaml
---
- name: This playbook install kubelet, kubectl and kubeadm on Debian 12 Bookworm
  hosts:
      - cplanes
      - workers
  tasks:
      - name: Check if target OS is Debian
        fail:
            msg: Stopped execution as the target OS is not Debian
        when: ansible_facts['os_family'] != "Debian"

      # source: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
      - name: Update and install required packages
        become: true
        ansible.builtin.shell: |
            sudo apt -y update
            sudo apt -y install apt-transport-https ca-certificates curl gnupg

      - name: Download the public signing key for the Kubernetes package repositories
        become: true
        ansible.builtin.shell: |
            sudo mkdir -p -m 755 /etc/apt/keyrings
            curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
            sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

      - name: Add the appropriate Kubernetes apt repository
        become: true
        ansible.builtin.shell: |
            # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
            echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
            sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

      - name: Update apt package index, then install kubectl, kubectl kubeadm
        become: true
        ansible.builtin.shell: |
            sudo apt -y update
            sudo apt -y install kubelet kubectl kubeadm
            sudo systemctl enable --now kubelet

      - name: Check installed versions
        register: out
        ansible.builtin.shell: |
            kubelet --version
            kubectl version
            kubeadm version
      - name: Show results
        debug: var=out.stdout_lines

      - name: Prevent kubernetes packages from being upgraded between versions
        become: true
        register: out2
        ansible.builtin.shell: |
            sudo apt-mark hold kubelet kubectl kubeadm
      - name: Show results
        debug: var=out2.stdout_lines
```

```sh
ansible-playbook -i inventory.yaml debian_install_kubelet_kubectl_and_kubeadm.yaml
```

Now, let setup `kubeadm init` on our `cplane1`. We do not have many master nodes, so we will make it manually.

```sh
# change to root user
sudo su

# reset
root@cplane1:/home/maciej# kubeadm reset
root@cplane1:/home/maciej# systemctl restart kubelet

# pull images before
root@cplane1:/home/maciej# kubeadm config images pull
[config/images] Pulled registry.k8s.io/kube-apiserver:v1.33.1
[config/images] Pulled registry.k8s.io/kube-controller-manager:v1.33.1
[config/images] Pulled registry.k8s.io/kube-scheduler:v1.33.1
[config/images] Pulled registry.k8s.io/kube-proxy:v1.33.1
[config/images] Pulled registry.k8s.io/coredns/coredns:v1.12.0
[config/images] Pulled registry.k8s.io/pause:3.10
[config/images] Pulled registry.k8s.io/etcd:3.5.21-0

# kubeadm and save the output text for later use (thanks to tee)
root@cplane1:/home/maciej# kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.178.200 --cri-socket=unix:///run/containerd/containerd.sock | tee kubeadm_init_store.txt
[init] Using Kubernetes version: v1.33.1
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action beforehand using 'kubeadm config images pull'
W0614 23:56:56.964635   30787 checks.go:846] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.10" as the CRI sandbox image.
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
[kubelet-check] The kubelet is healthy after 1.002154512s
[control-plane-check] Waiting for healthy control plane components. This can take up to 4m0s
[control-plane-check] Checking kube-apiserver at https://192.168.178.200:6443/livez
[control-plane-check] Checking kube-controller-manager at https://127.0.0.1:10257/healthz
[control-plane-check] Checking kube-scheduler at https://127.0.0.1:10259/livez
[control-plane-check] kube-controller-manager is healthy after 1.604780904s
[control-plane-check] kube-scheduler is healthy after 2.19017946s
[control-plane-check] kube-apiserver is healthy after 4.502816806s
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node cplane1 as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node cplane1 as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: qg4ly2.464mwd9p740muqbj
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

# configure .kube for root
root@cplane1:/home/maciej# export KUBECONFIG=/etc/kubernetes/admin.conf

# configure .kube for user
root@cplane1:/home/maciej# exit
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

# generate connection token for worker1
$ kubeadm token create --print-join-command

# generate connection token for worker2
$ kubeadm token create --print-join-command
```

Login to worker nodes and execute to join cluster. Remember to use `sudo`

```sh
# worker1
$ sudo kubeadm reset
$ sudo kubeadm join 192.168.178.200:6443 --token 8o34w9.jyhtv2av6l2ozv5d \
    --discovery-token-ca-cert-hash sha256:ab1a9a94e63fd993ba5b4959af0cea371cbb2339637bc1662de5f8121803bcbd

# worker2
$ sudo kubeadm reset
$ sudo kubeadm join 192.168.178.200:6443 --token fe4ev9.7kyn74qgn6izxej2 \
    --discovery-token-ca-cert-hash sha256:ab1a9a94e63fd993ba5b4959af0cea371cbb2339637bc1662de5f8121803bcbd
```

Now if we log in to `cplane1` and check the nodes, we should see them connected, but not yet in Ready state.

```sh
$ kubectl get node
NAME      STATUS     ROLES           AGE    VERSION
cplane1   NotReady   control-plane   11m    v1.33.1
worker1   NotReady   <none>          4m3s   v1.33.1
worker2   NotReady   <none>          11s    v1.33.1
```

### Configure CNI Plugin: Calico

It's time to take care of [install CNI Plugin Calico][weblink-calico-docs-quickstart]. We needs install it on the master, and the installer will make sure it also works on the workers nodes via DemonSet.

```sh
cat <<'EOF' | sudo tee /tmp/config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
networking:
  disableDefaultCNI: true
  podSubnet: 10.244.0.0/16
EOF

# install kind
$ [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
$ chmod +x ./kind
$ sudo mv ./kind /usr/local/bin/kind

# Start your Kubernetes cluster with the configuration file by running the following command:
$ sudo kind create cluster --name=calico-cluster --config=/tmp/config.yaml
Creating cluster "calico-cluster" ...
 ✓ Ensuring node image (kindest/node:v1.33.1) 🖼
 ✓ Preparing nodes 📦 📦 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing StorageClass 💾
 ✓ Joining worker nodes 🚜
Set kubectl context to "kind-calico-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-calico-cluster

Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂

$ kubectl get nodes
NAME      STATUS     ROLES           AGE   VERSION
cplane1   NotReady   control-plane   48m   v1.33.1
worker1   NotReady   <none>          41m   v1.33.1
worker2   NotReady   <none>          37m   v1.33.1

# install custom-resources.yaml
$ curl "https://raw.githubusercontent.com/projectcalico/calico/v3.30.1/manifests/custom-resources.yaml" -o /tmp/custom-resources.yaml
$ sed -i 's/192.168.0.0\/16/10.244.0.0\/16/g' custom-resources.yaml
$ kubectl create -f /tmp/custom-resources.yaml
installation.operator.tigera.io/default created
apiserver.operator.tigera.io/default created
goldmane.operator.tigera.io/default created
whisker.operator.tigera.io/default created

$ watch kubectl get tigerastatus
NAME        AVAILABLE   PROGRESSING   DEGRADED   SINCE
apiserver   False       True          False      6m
calico      False       True          False      6m
goldmane    False       True          False      5m
ippools     True        False         False      16m
whisker     False       True          False      5m
```

If there is no `True` in Available column and it holds for a while (like 5-10 minutes) there might be a problem.

If we see closer there is problem with `csi-node-driver` pods.

```sh
$ kubectl get pod -A
NAMESPACE          NAME                                       READY   STATUS              RESTARTS   AGE
calico-apiserver   calico-apiserver-6c46d554d6-st59f          1/1     Running             0          21m
calico-apiserver   calico-apiserver-6c46d554d6-wn4pz          1/1     Running             0          21m
calico-system      calico-kube-controllers-6c54c5578d-847bj   1/1     Running             0          21m
calico-system      calico-node-nmxtd                          1/1     Running             0          21m
calico-system      calico-node-nzdpc                          1/1     Running             0          21m
calico-system      calico-node-v2m69                          1/1     Running             0          21m
calico-system      calico-typha-78fc6f9595-mmt9f              1/1     Running             0          21m
calico-system      calico-typha-78fc6f9595-zzh4d              1/1     Running             0          21m
calico-system      csi-node-driver-5m9dr                      0/2     ContainerCreating   0          102s
calico-system      csi-node-driver-xdgn5                      2/2     Running             0          21m
calico-system      csi-node-driver-z9m57                      0/2     ContainerCreating   0          21m
calico-system      goldmane-86cd9d999d-4mqh2                  1/1     Running             0          21m
calico-system      whisker-f88d99f8d-5tsr9                    2/2     Running             0          21m
kube-system        coredns-674b8bbfcf-9qsr9                   1/1     Running             0          72m
kube-system        coredns-674b8bbfcf-sglsq                   1/1     Running             0          72m
kube-system        etcd-cplane1                               1/1     Running             1          72m
kube-system        kube-apiserver-cplane1                     1/1     Running             1          72m
kube-system        kube-controller-manager-cplane1            1/1     Running             0          72m
kube-system        kube-proxy-4959w                           1/1     Running             0          72m
kube-system        kube-proxy-9mhxx                           1/1     Running             0          61m
kube-system        kube-proxy-q296w                           1/1     Running             0          65m
kube-system        kube-scheduler-cplane1                     1/1     Running             1          72m
tigera-operator    tigera-operator-68f7c7984d-97qz7           1/1     Running             0          55m
```

If you installed `apparmor` (we did in my guide [Complete guide to install and configure Debian 12][post-install-and-configure-debian12]) you might have some problems to complete installation of Calico. You must disable `apparmor` and restart `containerd`.

```sh
sudo systemctl stop apparmor
sudo systemctl disable apparmor
sudo systemctl restart containerd.service
```

Now lets test, and all is ready.

```sh
$ kubectl get tigerastatus
NAME        AVAILABLE   PROGRESSING   DEGRADED   SINCE
apiserver   True        False         False      18m
calico      True        False         False      18m
goldmane    True        False         False      17m
ippools     True        False         False      34m
whisker     True        False         False      18m
```

Delete `kind` cluster

```sh
sudo kind delete cluster --name calico-cluster
```

Install `calicoctl` (optional)

```sh
wget -O calicoctl https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-amd64
chmod +x calicoctl
sudo mv calicoctl /usr/local/bin/


$ sudo calicoctl node status
Calico process is running.

IPv4 BGP status
+-----------------+-------------------+-------+----------+-------------+
|  PEER ADDRESS   |     PEER TYPE     | STATE |  SINCE   |    INFO     |
+-----------------+-------------------+-------+----------+-------------+
| 192.168.178.201 | node-to-node mesh | up    | 22:49:01 | Established |
| 192.168.178.202 | node-to-node mesh | up    | 22:49:01 | Established |
+-----------------+-------------------+-------+----------+-------------+

IPv6 BGP status
No IPv6 peers found.
```

## Setup helpers (like in CKAD)

Add to your `~/.bashrc` the `kubectl` shortcut to `k`, and autocomplete with `kubectl` and `kubeadm`.

```sh
cat <<'EOF' >> ~/.bashrc
alias k=kubectl' >> ~/.bashrc
source <(kubectl completion bash)
source <(kubeadm completion bash)
complete -o default -F __start_kubectl k
EOF
```

Development helpers

```sh
cat <<'EOF' | tee -a ~/.bashrc ~/.bashrc2
alias ..='cd ..'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# git
alias gst='git status'
alias ga='git add'
alias gaa='git add --all'
alias gsta='git stash push'
alias gstp='git stash pop'
alias grh='git reset'
alias gl='git pull'
alias gf='git fetch'
alias gcmsg='git commit --message'
EOF
```

### Enabling firewall

I put this section at the end as establishing good firewall configuration depends on the previously installed/used software. Below you will find configuration that should be healthy for the configuration from this article. Please use it if you know what you are doing as improper configuration may couse incorrect using of some services.

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

### Installing useful tools

```yaml
---
- name: This playbook install useful programs
  hosts:
      - cplanes
      - workers
  tasks:
      - name: Update and upgrade Debian packages
        become: true
        register: out
        ansible.builtin.shell: |
            apt -y update
            apt -y upgrade
      - name: Install programs
        become: true
        register: out
        ansible.builtin.shell: |
            # from registry
            apt -y install vim build-essential curl wget git kubens kubectx netstat iptables golang

            # k9s
            wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb
            apt -y install ./k9s_linux_amd64.deb
            rm k9s_linux_amd64.deb

      - name: Show results
        debug: var=out.stdout_lines
```

```sh
ansible-playbook -i inventory.yaml debian_install_useful_programs.yaml
```

## (optional) Bonus: Install NFS server

```sh
# cplane1
sudo mkdir -p /data/k8s # a location for persistant data
sudo chmod 1777 /data/k8s
echo "hello software" > /data/k8s/hello.txt

echo '/data/k8s/ *(rw,sync,no_root_squash,subtree_check)' >> /etc/exports

sudo exportfs -ra

sudo showmount -e localhost
```

```sh
## WORKER 1
sudo apt update
sudo apt install nfs-common nfs-kernel-server

sudo showmount -e cplane1 # or IP address

sudo su
root@worker1:/home/maciej# echo "cplane1:/data/k8s /mnt/k8s nfs defaults 0 2" >> /etc/fstab # 2 is for automount
root@worker1:/home/maciej# exit

sudo systemctl daemon-reload # reload config
sudo mkdir /mnt/k8s
sudo mount /mnt/k8s

ls -al /mnt/k8s # there should be hello file
```

```sh
## WORKER 2
sudo apt update
sudo apt install nfs-common nfs-kernel-server

sudo showmount -e cplane1 # or IP address

sudo su
root@worker1:/home/maciej# echo "cplane1:/data/k8s /mnt/k8s nfs defaults 0 2" >> /etc/fstab # 2 is for automount
root@worker1:/home/maciej# exit

sudo systemctl daemon-reload # reload config
sudo mkdir /mnt/k8s
sudo mount /mnt/k8s

ls -al /mnt/k8s # there should be hello file
```

## End

Wow that was hell of a journey! If you left till the end, I am impressed and my greatest congrats! Not everyone can achive such a perk!

As always I want to thank you for time and staying with me. Hoping you had as much fun reading and following commands, as I had while preparing and documenting each step for this article. Stay save and until next time.

### Resources

- <https://docs.docker.com/engine/install/ubuntu/>
- <https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/>
- <https://www.baeldung.com/ops/kubernetes-uninstall>
- <https://www.howtoforge.com/how-to-setup-kubernetes-cluster-with-kubeadm-on-ubuntu-22-04/>
- <https://www.linuxtechi.com/install-kubernetes-on-ubuntu-22-04/>
- <https://www.servethehome.com/introducing-project-tinyminimicro-home-lab-revolution/hp-elitedesk-705-g3-kubernetes/>
- <https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart>
- <https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html>

## FAQ

### Error after node restart

```sh
$ kubectl get pod
The connection to the server 192.168.178.200:6443 was refused - did you specify the right host or port?
```

Did you install `apparmor` if so this could be a problem that some files important to system are blocked. Try:

```

```

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

[post-home-k8s-cluster]: {{ site.baseurl }}{% link _posts/2024-08-26-home-k8s-cluster.md %}
[post-install-and-configure-debian12]: {{ site.baseurl }}{% link _posts/2025-06-11-complete-guide-to-install-and-configure-debian-12 copy.md %}
[weblink-flannel-github]: https://github.com/flannel-io/flannel
[weblink-ansible-docs]: https://docs.ansible.com/
[weblink-ansible-cli-docs]: https://docs.ansible.com/ansible/latest/cli/ansible.html
[weblink-calico-docs]: https://docs.tigera.io/calico/latest/getting-started/kubernetes/hardway/install-cni-plugin
[weblink-debian-download]: https://www.debian.org/distrib/
[weblink-calico-docs-quickstart]: https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart
