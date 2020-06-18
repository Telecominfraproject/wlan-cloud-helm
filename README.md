# wlan-cloud-helm
This repository contains helm charts for various deployment types of the tip wlan cloud services.

# Deploying the wlan-cloud deployment
 - Run the following command under tip-wlan-helm directory:
 	- helm install <RELEASE_NAME> tip-wlan/ -n default -f tip-wlan/resources/environments/dev.yaml
	
	More details can be found here: https://telecominfraproject.atlassian.net/wiki/spaces/WIFI/pages/262176803/Pre-requisites+before+deploying+Tip-Wlan+solution

# Deleting the wlan-cloud deployment:
- Run the following command:
	- helm del tip-wlan -n default
	
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
