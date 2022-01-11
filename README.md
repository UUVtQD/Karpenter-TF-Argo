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
- [Karpenter](#karpenter)
- [Examples](#examples)
- [Credits](#credits)
  - [doctoc usage](#doctoc-usage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## TF Code

### General information
I have created a separate AWS profile named `pg` (**p**lay**g**round) for testing purposes only

The [hashicorp/learn-terraform-provision-eks-cluster](https://github.com/hashicorp/learn-terraform-provision-eks-cluster) module was used as a basis.

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
```

## ArgoCD 

## Karpenter

## Examples

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
