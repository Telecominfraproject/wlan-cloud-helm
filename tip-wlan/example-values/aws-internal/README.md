# Helm values for deploying a cloud controller onto an AWS EKS cluster with internal accessibility

These values are almost the same as you can find in [aws-basic](../aws-basic) example values, but this case adds required annotations to make your installaion work in private mode without any endpoints exposed to the Internet.

[Detailed instructions](https://openwifi.tip.build/getting-started/controller-installation/aws-install)

[This Terraform module](https://github.com/Telecominfraproject/wlan-cloud-terraform/tree/master/aws-cloudsdk) can be used to set up the required EKS cluster including all necessary addons.

