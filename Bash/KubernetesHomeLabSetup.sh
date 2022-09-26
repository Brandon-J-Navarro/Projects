#FROM
    #SOURCES :   
        #https://www.virtualizationhowto.com/2021/06/kubernetes-home-lab-setup-step-by-step/
        #https://www.aquasec.com/cloud-native-academy/kubernetes-101/kubernetes-dashboard/
        #https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
        #https://youtu.be/_WW16Sp8-Jw

#Kubernetes Home Lab Setup Step-by-Step

#In this Kubernetes home lab setup, I will be using the following:

    #Windows 11 Pro Hyper-V (CPU i7-4770K 4C-8T, 32GB RAM, 240GB SSD Boot, 2TB SSD Storage)
    #(3) Ubuntu 22.04 server virtual machines (2vCPUs, 4096MB RAM, 127GB HDD)
    #Kubeadm to initialize and provision the Kubernetes cluster
    #Flannel as the container network interface
    #Installing the Kubernetes Dashboard

#Let’s look at the following steps to provision the Kubernetes home lab setup:

    #Install DockerIO and change Docker to Systemd
    #Install Kubeadm
    #Initialize the Kubernetes cluster
        #Export admin config
        #Provision the network overlay
    #Join worker nodes
    #Install the Kubernetes Dashboard

#1. Install Docker Container Runtime

#You need to install a container runtime into each of your Kubernetes nodes for running Pods. Docker is the most popular option, so that is what I have installed in each of my Ubuntu #22.04 virtual machines. To install Docker in Ubuntu, use the following command:

sudo apt install docker.io

#Create and Add user to docker group

sudo usermod -aG docker $USER && newgrp docker

#You will want to change Docker daemon to use systemd for the management of the container’s cgroups. To do this, after installing Docker, run the following:

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

#Restart your Docker services

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

#2. Install Kubeadm

#Kubeadm is a tool that helps to install and configure a Kubernetes cluster in a much easier way than performing all steps manually. It helps to bootstrap a Kubernetes cluster with the necessary minimum configuration needed to get the Kubernetes cluster up and running. To install kubeadm, perform the following in Ubuntu. This updates the package index and installs packages needed to use Kubernetes apt repo, downloads the Google Cloud public signing key, adds the Kubernetes apt repo, and installs kubelet, kubeadm, and kubectl.

sudo apt update && sudo apt upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
#Kubeadm init had errors with docker container runtime version 1.23 was a work arround
sudo apt-get install -qy kubelet=1.23.1-00 kubectl=1.23.1-00 kubeadm=1.23.1-00
sudo apt-mark hold kubelet kubeadm kubectl

kubeadm config images pull

sudo swapoff -a

#3. Initialize the Kubernetes Cluster (MASTER NODE ONLY)

#After installing kubeadm, we can use it to initialize the Kubernetes cluster. To do that, use the following command:

#kubeadm init --pod-network-cidr=<your pods CIDR>
#Example:  kubeadm init --pod-network-cidr=10.244.0.0/16
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=Mem

#Your Kubernetes control-plane has initialized successfully!

#To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  export KUBECONFIG=$HOME/.kube/config

#Alternatively, if you are the root user, you can run:

  #export KUBECONFIG=/etc/kubernetes/admin.conf

#You should now deploy a pod network to the cluster.
#Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  ##https://kubernetes.io/docs/concepts/cluster-administration/addons/

#Then you can join any number of worker nodes by running the following on each as root:

#kubeadm join X.X.X.X:XXXX --token XXXXXXXXXXXXXXXXXX --discovery-token-ca-cert-hash sha256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#Exporting the kube/config file and copying the command to join kubernetes worker nodesExporting the config and copying the command to join kubernetes worker nodes

#There are many networking solutions available for Kubernetes. You can find the full list and links here: Cluster Networking | Kubernetes. The next step is to provision the network overlay. I am using the Flannel network. To use it, run the following:

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#Setting up the flannel container network pluginSetting up the flannel container network plugin

#4. Join Worker Nodes

#To join Kubernetes worker nodes to the Kubernetes cluster, simply run the command that is displayed after you initialize the Kubernetes cluster with kubeadm. **Note** This will be run from the worker nodes. It will look something like this:

sudo mkdir -p $HOME/.kube
sudo nano .kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

sudo kubeadm join X.X.X.X:XXXX --token XXXXXXXXXXXXXXXXXX --discovery-token-ca-cert-hash sha256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#Joining a worker node to the kubernetes clusterJoining a worker node to the kubernetes cluster
#Master and two worker nodes running in the kubernetes clusterMaster and two worker nodes running in the kubernetes cluster
#After joining the workers, as you can see below, you will see Flannel pods for your workers running.
#Flannel pods up and runningFlannel pods up and running

kubectl get nodes
kubectl get pods --all-namespaces
kubectl cluster-info

#5. Install the Kubernetes Dashboard

#You most likely will want to install the Kubernetes dashboard. To install the Kubernetes Dashboard, grab the latest YAML file from here: Web UI (Dashboard) | Kubernetes

#The script will look like this:

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

#Deploy the kubernetes dashboard using the official yaml scriptDeploy the kubernetes dashboard using the official yaml script

#Setup Nodeport networking by editing the kubernetes-dashboard svc. To do that, run the command:

kubectl -n kubernetes-dashboard edit svc kubernetes-dashboard

#Edit the type to NodePort and add the nodePort section under ports. Choose an arbitrary port been 30000-32767.

#"ctrl+i" to insert text | "esc" to exit edit mode | ":wq" to write and quit | ":q!" to quit with out changes

#Editing the kubernetes dashboard service for nodeport connectivityEditing the kubernetes dashboard service for nodeport connectivity

#Verify the Kubernetes-dashboard service using:

kubectl -n kubernetes-dashboard get svc

#Create a Service Account in the namespace kubernetes-dashboard

dashboard-adminuser.yaml 
    apiVersion: v1
    kind: ServiceAccount
    metadata:
        name: admin-user
        namespace: kubernetes-dashboard

kubectl apply -f dashboard-adminuser.YAML

#We’ll assume a cluster-admin ClusterRole already exists in your cluster. Use the following code to bind the new account to it, using a ClusterRoleBinding. If there is no such role, create it and grant the required privileges. 

ClusterRoleBinding.yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
        name: admin-user
    roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: cluster-admin
    subjects:
      - kind: ServiceAccount
        name: admin-user
        namespace: kubernetes-dashboard

kubectl apply -f ClusterRoleBinding.yaml

#Get a bearer token for the new account, which you can use to log in. Use the following command (in one line). The command uses the account name in the example above, admin-user

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

#Copy the token from the console and paste it into the Enter token field on the Kubernetes Dashboard login screen. Click Sign in to log into the dashboard as administrator.

#Verifying the kubernetes dashboard service afterwardsVerifying the kubernetes dashboard service afterwards
#Accessing the kubernetes dashboard from the nodeportAccessing the kubernetes dashboard from the nodeport

#This post has walked through a basic quick configuration of getting a Kubernetes home lab setup step-by-step with a few commands to run. Keep in mind using this approach you need to have your own VMs that will serve as Kubernetes worker nodes as well as the control node or master