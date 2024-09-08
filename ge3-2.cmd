lab start nodes-operators
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc get nodes
oc get pods -n openshift-cluster-node-tuning-operator
oc get profile -n openshift-cluster-node-tuning-operator
oc get tuneds.tuned.openshift.io -n openshift-cluster-node-tuning-operator -o yaml
Check cat /sys/kernel/mm/transparent_hugepage/enabled in worker01
oc debug node/worker01
vi stabledbCR.yml
oc apply -f stabledbCR.yml
oc get profile -n openshift-cluster-node-tuning-operator
Check cat /sys/kernel/mm/transparent_hugepage/enabled in worker01
oc debug node/worker01
cd
lab finish nodes-operators

