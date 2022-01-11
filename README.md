# Karpenter-TF-Argo

this repo contains sample code to set up EKS Cluster(link-to-extenal-web-URL), ArgoCD Appication(link), and Karpenter(link) with some examples.

. place doc-toc placeholder here

## TF Code

I have created a separate AWS profile named `pg` (**p**lay**g**round) for testing purposes only

The [terraform-aws-modules/terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks) module was used as a basis.

To run this Terraform code the next command was used:

```bash
AWS_PROFILE=pg terraform plan
AWS_PROFILE=pg terraform apply
```

The presented code creates the next resources:
- VPC (subnets, route tables, nat and internet gateways, flow logs, policies, eip)
- kms key
- EKS

For detailed information please see the code.

## ArgoCD 

## Karpenter

## Examples

## Credits