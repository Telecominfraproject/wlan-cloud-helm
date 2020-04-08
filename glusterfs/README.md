# GlusterFS on kubernetes

The goal of this project is to spin-up GlusterFS on Kubernetes, so we can use the cluster as a Storage class in our environment.

This project is based on the gluster-kubernetes project - https://github.com/gluster/gluster-kubernetes. 
It follows the instructions described in the setup guide (https://github.com/gluster/gluster-kubernetes/blob/master/docs/setup-guide.md). 
However, there are subtle differences:

- We are using Ubuntu (Debian based) instead of CentOS as the base OS. Hence a few package/commands are different.
- Certain resource types are different in Kubernetes 1.17/1.18:
    - Hence need to update the yamls
    - Also need to update the deploy script
- Based on the issues seen, we need to run a few pods on the master nodes. See page for details: https://connectustechnologies.atlassian.net/wiki/spaces/TW/pages/123732038/Creating+GlusterFS+on+Kubernetes (see Error-6)

# Pre-requisite of running the gk-deploy script:
- Need to have Kubernetes running on 3 nodes setup with Glusterfs-client installed on all the nodes
- Preferably a separate volume should be attached to these nodes.
- gk-deploy script will create a new namespace "gluster-ns"

For other issues faced during deployment, see here: 
- https://connectustechnologies.atlassian.net/wiki/spaces/TW/pages/123732038/Creating+GlusterFS+on+Kubernetes

# Usage
- Creation:
  ./gk-deploy -g --admin-key <ADMIN_KEY> --user-key <USER_KEY> -n <GLUSTER_NAMESPACE> -v topology.json. 
  - As an example: ./gk-deploy -g --admin-key admin --user-key user -n glusterns -v topology.json
  - Namespace specifics: 
    - If namespace is passed, we will create (if it does not exist) and use that namespace for glusterFS resources.
    - If namespace is NOT passed, we will create (if it does not exist) namespace='gluster-ns' and use it for glusterFS resources.


- Deletion:
  ./gk-deploy --admin-key <ADMIN_KEY> --user-key <USER_KEY> --abort -v
  Note: this won't delete the glusterfs pods. To remove the pods, delete the daemon set, then delete the namespace - 'gluster-ns':
  Example:
    - kubectl delete daemonset glusterfs
    - kubectl delete namespace gluster-ns

