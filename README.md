# wlan-cloud-helm
This repository contains helm charts for various deployment types of the tip wlan cloud services.

# Migration to upstream third parties stateful charts

## Prerequisites

1. Checkout latest wlan-cloud-helm repository
2. Have your certificates for existing installation
3. Helm 3.2+

## Procedure

1. First, you need to delete the old helm release, because this migration is a breaking change (this doesn't delete PVC):
```
helm list -n default (to look up the name)
helm uninstall -n default tip-wlan (tip-wlan is usually the name)
```
2. Replace `REPLACEME` with your storage class name in migration.yaml
3. Update your values file that you used to deploy this chart with the values from migration.yaml to support thirdparties and preserve existing cassandra\postgres data. You need to override existing values for postgres\cassandra\kafka and add the creds property and sub properties to the global values (it used to be under cassandra). This step can be skipped if you choose to use helm to merge those values.
4. You need to remove old charts from helm, so that helm can successfully pull new ones (if you are doing this in place, if you copied new helm chart to another directory you can skip this):
```
rm -rf tip-wlan/charts/cassandra tip-wlan/charts/kafka tip-wlan/charts/postgresql
```
5. Then you need to copy the certificates to a new location (if you are doing this in place, otherwize checkout the latest wlan-pki-cert-script repo and use `copy-certs-to-helm.sh %path_to_new_helm_code%` from that repo):
```
find . -regextype posix-extended -regex '.+(jks|pem|key|pkcs12|p12)$' -exec cp "{}" tip-wlan/resources/certs/ \;
```
6. Then you need to update subcharts:
```
helm dependency update
```
7. Last step is to perform your upgrade:
```
helm upgrade --install tip-wlan tip-wlan/ --namespace tip --create-namespace -f .\resources\environments\your_values_with_fixes.yaml
```

Alternatively, if you skipped №3, you can do this (order matters, do not reorder -f arguments):

```
helm upgrade --install tip-wlan tip-wlan/ --namespace tip --create-namespace -f .\resources\environments\original_values.yaml -f .\resources\environments\migration.yaml
```

As a precaution you can also do `helm template` with the same arguments and examine the output before actually installing the chart

# Deploying the wlan-cloud deployment
Run the following command under tip-wlan-helm directory:
```
helm upgrade --install <RELEASE_NAME> tip-wlan/ --namespace tip  --create-namespace -f tip-wlan/resources/environments/dev.yaml
```

More details can be found here: https://telecominfraproject.atlassian.net/wiki/spaces/WIFI/pages/262176803/Pre-requisites+before+deploying+Tip-Wlan+solution

# Deleting the wlan-cloud deployment:
Run the following command:
```
helm del tip-wlan -n default
```
	(Note: this would not delete the tip namespace and any PVC/PV/Endpoints under this namespace. These are needed so we can reuse the same PVC mount when the pods are restarted.)
	
	To get rid of them (PVC/PV/Endpoints), you can use the following script (expects that you are in the `tip` namespace or add `-n tip` to the below set of commands):
	```
	#!/bin/bash
	# Usage: ./cleanup-pvc-gluster-resources.sh <namespace to delete>
	# script to remove gluster-dynamic-endpointsm, gluster-dynamic-svc and pvc that are retained after
	# helm del of the release.
	# NOTE: we are not deleting the namespace, to avoid deletion of any resource by mistake.
	kubectl get endpoints --no-headers -o custom-columns=":metadata.name"  | xargs kubectl delete endpoints
	kubectl get svc --no-headers -o custom-columns=":metadata.name"  | xargs kubectl delete svc
	kubectl get pvc --no-headers -o custom-columns=":metadata.name"  | xargs kubectl delete pvc
	kubectl get pv --no-headers -o custom-columns=":metadata.name"  | xargs kubectl delete pv
	```

# Running tests under wlan-cloud deployment
 Currently we have tests for:
 - Cassandra: Test that verifies the following in a running Cassandra cluster:
 	- Keyspace, Table creation
	- Insert a record in the Table
	- Select the record
	- Delete Table
	- Delete Keyspace (to enable us to run the test again)
		- NOTE: For the test to work, make sure that the cluster-size remains the same, if you are redeploying the chart using helm-del and helm-install with existing pvc.
 - Kafka: Test that verifies:
	- Creating a topic
	- Posting a message on topic
	- Consuming a message from topic
	- Changing the retention period of a topic to 1 sec
	- Marking the topic for deletion (to enable us to run the test again)

 - Run the following command under tip-wlan-helm directory _after_ the components are running:
 	- helm test <RELEASE_NAME> -n default
	(For more details add --debug flag to the above command) 


# Local environment

In `wlan-pki-cert-scripts` repository edit the following files and add/replace strings as specified below:

```
mqtt-server.cnf:

-commonName_default   = opensync-mqtt-broker.zone1.lab.wlan.tip.build
+commonName_default   = opensync-mqtt-broker.wlan.local


openssl-server.cnf:
-DNS.1  = opensync-redirector.zone1.lab.wlan.tip.build
-DNS.2  = opensync-controller.zone1.lab.wlan.tip.build
+DNS.1  = opensync-redirector.wlan.local
+DNS.2  = opensync-controller.wlan.local
 DNS.3  = tip-wlan-postgresql
-DNS.4  = ftp.example.com
```

In `wlan-pki-cert-scripts` repository run `./generate_all.sh` to generate CA and certificates, then run `./copy-certs-to-helm.sh <local path to wlan-cloud-helm repo>` in order to copy certificates to helm charts.

Optionally, in order to speedup first and subsequent runs, you may cache some images:

```
minikube cache add zookeeper:3.5.5
minikube cache add bitnami/postgresql:11.8.0-debian-10-r58
minikube cache add postgres:latest
minikube cache add gcr.io/k8s-minikube/storage-provisioner:v3
minikube cache add eclipse-mosquitto:latest
minikube cache add opsfleet/depends-on
```

These images may occasionally need to be updated with these commands:

```
minikube cache reload ## reload images from the upstream
eval $( minikube docker-env )
for img in $( docker images --format '{{.Repository}}:{{.Tag}}' | egrep 'busybox|alpine|confluentinc/cp-kafka|zookeeper|k8s.gcr.io/pause|nginx/nginx-ingress|bitnami/cassandra|bitnami/postgresql|postgres|bitnami/minideb' ); do
	minikube cache add $img;
done
```

Run minikube:

```minikube start --memory=10g --cpus=4 --driver=virtualbox --extra-config=kubelet.serialize-image-pulls=false --extra-config=kubelet.image-pull-progress-deadline=3m0s --docker-opt=max-concurrent-downloads=10```

Please note that you may choose another driver (parallels, vmwarefusion, hyperkit, vmware, docker, podman) which might be more suitable for your setup. Omitting this option enables auto discovery of available drivers.

Deploy CloudSDK chart:

```helm upgrade --install tip-wlan tip-wlan -f tip-wlan/resources/environments/dev-local.yaml -n default```

Wait a few minutes, when all pods are in `Running` state, obtain web ui link with `minikube service tip-wlan-wlan-cloud-static-portal -n tip --url`, open in the browser. Importing or trusting certificate might be needed.

Services may be exposed to the local machine or local network with ssh, kubectl or kubefwd with port forwarding, please examples below.

Kubefwd:

kubefwd is used to forward Kubernetes services to a local workstation, easing the development of applications that communicate with other services. It is for development purposes only. For production/staging environments services need to be exposed via load balancers.
Download latest release from https://github.com/eugenetaranov/kubefwd/releases and run the binary.

Forward to all interfaces (useful if you need to connect from other devices in your local network):

```
sudo kubefwd services --namespace tip -l "app.kubernetes.io/name in (nginx-ingress-controller,wlan-portal-service,opensync-gw-cloud,opensync-mqtt-broker)" --allinterfaces --extrahosts wlan-ui-graphql.wlan.local,wlan-ui.wlan.local
```

Kubectl port forwarding (alternative to kubefwd):
```
kubectl -n tip port-forward --address 0.0.0.0 $(kubectl -n tip get pods -l app=tip-wlan-nginx-ingress-controller -o jsonpath='{.items[0].metadata.name}') 443:443 &
kubectl -n tip port-forward --address 0.0.0.0 $(kubectl -n tip get pods -l app.kubernetes.io/name=wlan-portal-service -o jsonpath='{.items[0].metadata.name}') 9051:9051 &
kubectl -n tip port-forward --address 0.0.0.0 $(kubectl -n tip get pods -l app.kubernetes.io/name=opensync-gw-cloud -o jsonpath='{.items[0].metadata.name}') 6643:6643 &
kubectl -n tip port-forward --address 0.0.0.0 $(kubectl -n tip get pods -l app.kubernetes.io/name=opensync-gw-cloud -o jsonpath='{.items[0].metadata.name}') 6640:6640 &
kubectl -n tip port-forward --address 0.0.0.0 $(kubectl -n tip get pods -l app.kubernetes.io/name=opensync-mqtt-broker -o jsonpath='{.items[0].metadata.name}') 1883:1883 &
```

Add certificate to the trust store.

Firefox:

1. Open settings, `Privacy and security`, `View certificates`.

2. Click on `Add Exception...`, enter `https://wlan-ui.wlan.local` into Location field, click on `Get certificate`, check `Permanently store this exception` and click on `Confirm Security Exception`.
Repeat the step for `https://wlan-ui-graphql.wlan.local`


Chrome and other browsers using system certificate store:

1. Save certificate below into the file `wlan-ui-graphql.wlan.local.crt` (it is the one defined at tip-wlan/resources/environments/dev-local.yaml:143):

```
-----BEGIN CERTIFICATE-----
MIIFWjCCA0KgAwIBAgIUQNaP/spvRHtBTAKwYRNwbxRfFAswDQYJKoZIhvcNAQEL
BQAwHTEbMBkGA1UEAwwSd2xhbi11aS53bGFuLmxvY2FsMB4XDTIwMDgyNzIwMjY1
NloXDTMwMDgyNTIwMjY1NlowHTEbMBkGA1UEAwwSd2xhbi11aS53bGFuLmxvY2Fs
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwRagiDWzCNYBtWwBcK+f
TkkQmMt+QAgTjYr0KS8DPJCJf6KkPfZHCu3w4LvrxzY9Nmieh2XU834amdJxIuCw
6IbNo6zskjsyfoO8wFDmlLVWLeg5H9G9doem+WTeKPaEHi3oquzNgt6wLs3mvvOA
TviTIoc88ELjk4dSR2T4dhh0qKCCj+HdXBA6V/9biru+jV+/kxEQuL2zM39DvVd8
9ks35zMVUze36lD4ICOnl7hgaTNBi45O9sdLD0YaUmjiFwQltJUdmPKpaAdbvjUO
nsupnDYjm+Um+9aEpqM4te23efC8N8j1ukexzJrE2GeF/WB/Y1LFIG2wjqVnsPcs
nFF4Yd9EBRRne1EZeXBu3FELFy6lCOHI146oBcc/Ib617rdTKXqxtv/2NL6/TqFk
ns/EEjve6kQYzlBZwWHWpZwQfg3mo6NaoFZpTag98Myu5rZoOofTcxXH6pLm5Px1
OAzgLna9O+2FmA4FjrgHcMY1NIzynZL+DH8fibt1F/v2F2MA+R9vo84vR5ROGNdD
va2ApevkLcjQg/LwsXv0gTopQ/XIzejh6bdUkOrKSwJzT2C9/e9GQn0gppV8LBuK
1zQHoROLnA41MCFvQLQHo+Xt8KGw+Ubaly6hOxBZF51L/BbqjkDH9AEFaJLptiEy
qn1E5v+3whgFS5IZT8IW5uUCAwEAAaOBkTCBjjAdBgNVHQ4EFgQUy2bAUyNPXHS9
3VTSD+woN7t3q8EwHwYDVR0jBBgwFoAUy2bAUyNPXHS93VTSD+woN7t3q8EwDwYD
VR0TAQH/BAUwAwEB/zA7BgNVHREENDAyghp3bGFuLXVpLWdyYXBocWwud2xhbi5s
b2NhbIIOYXBpLndsYW4ubG9jYWyHBMCoAAEwDQYJKoZIhvcNAQELBQADggIBAKH+
bqJee11n34SYgBDvgoZ8lJLQRwsFnqExcSr/plZ7GVIGFH5/Q2Kyo9VyEiTPwrIs
KsErC1evH6xt1URfMzp05zVQ0LYM5+ksamRDagAg3M1cm7oKOdms/dqzPe2gZfGJ
pVdtVW1CHrL0RLTR93h7kgSiBlSEIYMoeKfN5H9AavJ4KryygQs63kkGQ5M9esAp
u6bB307zyfzgS3tmQsU01rgJfhEHQ/Y+Ak9wDuOgvmfx0TWgAOGbKq6Tu8MKYdej
Ie7rV1G5Uv7KfgozVX76g2KdnTVBfspSKo3zyrZkckzApvUu9IefHdToe4JMEU0y
fk7lEU/exzByyNxp+6hdu/ZIg3xb1yA1oVY8NEd1rL1zAViPe351SENEKeJpRanC
kCL3RAFkbxQ7Ihacjox8belR+gmo8cyFZpj9XaoPlSFScdwz573CT0h97v76A7sw
yC+CiSp85gWEV5vgBitNJ7R9onjBdsuH2lgEtMD3JNOs8cCSRihYxriwZSqhT7o/
tcIlcJ84W5m6X6zHJ3GmtuKG3QPNOms0/VVoDTp9qdpL+Ek17uB2A41Npxz3US+l
6yK+pdQQj7ALzKuRfOyg80XbNw2v4SnpI5qbXFBRum52f86sPemFq1KcuNWe4EVC
xDG3eKlu+dllUtKx/PN6yflbT5xcGgcdmrwzRaWS
-----END CERTIFICATE-----

```

2. Double click on it, enter the system admin password, if prompted.
