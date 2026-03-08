☸️ Automated Kubernetes Cluster Deployment
============================================

Welcome! If you've set aside a few hours to dive into Infrastructure as Code (IaC) and Cluster Orchestration, you're in the right place. This project automates the provisioning of AWS EC2 instances using Terraform and the configuration of a Kubernetes (v1.31) cluster using Ansible.

🛠 Prerequisites
-----------------
Before starting, ensure you have the following tools installed:

* Terraform & Ansible
* Python 3
* SSH Client (WSL2/MobaXterm for Windows, iTerm2 for macOS)

1. Security & Keys
Generate a 4096-bit RSA key pair for secure access to your instances:

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
Your keys are typically stored in ~/.ssh/id_rsa.pub.

🚀 Getting Started
-------------------
1. Clone the Repository:
   
* It is recommended to clone this into your Linux home directory (especially if using WSL2) to avoid permission issues:

```bash
cd ~
git clone [<your-repo-link>](https://github.com/Arunsenthil-ece/Kubernetes_deployment.git)
cd kubernetes_deployment
```

2. Infrastructure Provisioning (Terraform):
   
* Configure AWS: Place your config and credentials files in the Terraform/ folder.
* Setup Variables: * Open Terraform/terraform.tfvars and paste your public key in the public_key field.
     * In Terraform/modules/create_cluster/variables.tf, update local.my_ip with your public IP (found via "What is my IP" on Google). This restricts SSH access to your machine only.

Deploy:

```bash
cd Terraform
terraform init
terraform plan
terraform apply -auto-approve
```

3. Cluster Configuration (Ansible):
   
* Once your EC2 instances are "Green" in the AWS Console, go back to the root directory to generate your inventory:

```bash
cd ..
python3 create_inventory.py
```
Now, move to the Ansible directory and execute the playbooks. These will install containerd, kubeadm, and initialize the nodes:

```bash
cd Ansible
ansible-playbook -i inventory.ini controlplane-playbook.yml
ansible-playbook -i inventory.ini workernode-playbook.yml
```

🔍 Verification
Log in to your Control Plane node to verify the cluster state:

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<control-plane-ip>
```

Check the status of your nodes:
```bash
kubectl get nodes
```

Deploy a Test Pod
Verify that the CNI (Calico) and Scheduling are working:

```bash
kubectl run test-nginx --image=nginx
kubectl get pods
```
If you see test-nginx in a Running state... Tada! You have a fully functional Kubernetes cluster. 🥂

⚠️ Important Notes
-------------------
Cgroup Driver: This project uses systemd as the cgroup driver for containerd to match Kubernetes 1.31 defaults.

Networking: Calico is used for the Pod Network (Default CIDR: 192.168.0.0/16).

Cleanup: Don't forget to run terraform destroy when you are finished to avoid AWS costs!
