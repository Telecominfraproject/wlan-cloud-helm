# wlan-cloud-helm
This repository contains helm charts for various deployment types of the tip wlan cloud services.

# Deploying the wlan-cloud deployment
 - Run the following command under tip-wlan-helm directory:
 	- helm install <RELEASE_NAME> tip-wlan/ -n default -f tip-wlan/resources/environments/dev.yaml
	
	More details can be found here: https://connectustechnologies.atlassian.net/wiki/spaces/TW/pages/96895055/Pre-requisites+before+deploying+Tip-Wlan+solution

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
