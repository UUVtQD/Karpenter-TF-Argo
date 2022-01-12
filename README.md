# Karpenter-TF-Argo

this repo contains sample code to set up EKS Cluster(link-to-extenal-web-URL), ArgoCD Appication(link), and Karpenter(link) with some examples.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [TF Code](#tf-code)
  - [General information](#general-information)
  - [Provision the EKS cluster](#provision-the-eks-cluster)
  - [Configure kubectl](#configure-kubectl)
- [ArgoCD](#argocd)
  - [Install ArgoCD](#install-argocd)
- [Karpenter](#karpenter)
  - [General information](#general-information-1)
  - [Installation](#installation)
  - [Examples](#examples)
- [Credits](#credits)
  - [doctoc usage](#doctoc-usage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## TF Code

### General information
I have created a separate AWS profile named `pg` (**p**lay**g**round) for testing purposes only

The [hashicorp/learn-terraform-provision-eks-cluster](https://github.com/hashicorp/learn-terraform-provision-eks-cluster) module was used as a basis, some code/examples were taken from [terraform-aws-modules/terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks)

### Provision the EKS cluster
To run this Terraform code the next command was used:

```bash
AWS_PROFILE=pg terraform plan
AWS_PROFILE=pg terraform apply
```

The presented code creates the next resources:
- vpc.tf: provisions a VPC, subnets and availability zones using the AWS VPC Module. A new VPC is created for this tutorial so it doesn't impact your existing cloud environment and resources.

- security-groups.tf: provisions the security groups used by the EKS cluster.

- eks-cluster.tf: provisions all the resources (AutoScaling Groups, etc...) required to set up an EKS cluster using the AWS EKS Module.

- outputs.tf: defines the output configuration.

- versions.tf: sets the Terraform version to at least 0.14. It also sets versions for the providers used in this sample.

For more details see the source code.

### Configure kubectl

For testing purposes - define kubeconfig file separate from defaults:

```bash
export KUBECONFIG=$(pwd)/.kubeconfig
```

Run the following command to retrieve the access credentials for your cluster and automatically configure kubectl:

```bash
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name) --profile=pg
```

Test the command:

```bash
k get nodes
NAME                                          STATUS   ROLES    AGE     VERSION
ip-10-0-2-121.eu-central-1.compute.internal   Ready    <none>   5m15s   v1.21.5-eks-bc4871b
```

## ArgoCD

### Install ArgoCD

Install ArgoCD with the next command:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
By default, the Argo CD API server is not exposed with an external IP. To access the API server without exposing the service port-forwarding will be used:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
```
The API server can then be accessed using the localhost:8080

Retrieve default password using `kubectl`:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

LogIn via CLI and change the password:

```bash
argocd login --username admin localhost:8080
WARNING: server certificate had error: x509: certificate signed by unknown authority. Proceed insecurely (y/n)? yes
Password: 
'admin:login' logged in successfully
Context 'localhost:8080' updated
```

Change the password using the command:

```bash
argocd account update-password
*** Enter current password: 
*** Enter new password: 
*** Confirm new password: 
Password updated
Context 'localhost:8080' updated
```

Test new password: log in into WebUI using `https://locahost:8080` address

## Karpenter

### General information

### Installation
We will install the `karpenter` using ArgoCD with `helm` release.

To install karpenter with ArgoCD we need to create an application. There are two ways to do that: via webUI or via `yaml + kubectl`. 

Regardless of method, the next parameters have to be added to the helm manifest:


1. IAM role Karpenter needs to assume (connect the `KarpenterController IAM Role` to ServiceAccount)
    ```yaml
    - name: "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value: arn:aws:iam::373776396355:role/karpenter-controller-karpenter-eks-JXniQCJD
    ```
2. Cluster details - EKS cluster name:
    ```yaml
    - name: controller.clusterName
      value: karpenter-eks-JXniQCJD
    ```
    can be retrieved via CLI/terraform output command
3. Cluster details - EKS cluster endpoint:
    ```yaml
    - name: controller.clusterEndpoint
      value: https://E05702F69E8F31AA6E7A2AD14FE3D77E.gr7.eu-central-1.eks.amazonaws.com
    ```
    can be retrieved via CLI/terraform output command

For complete example of YAML manifest please see the [karpenter-argo-app.yaml file](./karpenter-argo-app.yaml)  


### Examples

## Credits

### doctoc usage

Define location of TOC, and indicate it usin the next placeholders:

```xml
<!-- START doctoc -->
<!-- END doctoc -->
```

After that, run the sample command:

```bash
doctoc README.md --github --title '**Table of Contents**'
```

For more information refer to the [official documentation here](https://www.npmjs.com/package/doctoc)
