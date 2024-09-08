lab start nodes-mco
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc project nodes-mco
oc get nodes
oc get machineconfig -l machineconfiguration.openshift.io/role=worker
oc get machineconfig -l machineconfiguration.openshift.io/role=custom
oc label node/worker01 node-role.kubernetes.io/custom=
oc get nodes
vim custom-mcp.yml
oc create -f custom-mcp.yml
oc get mcp
oc get events -n openshift-machine-config-operator --sort-by='{.lastTimestamp}' --field-selector involvedObject.name=custom
oc get mc --selector machineconfiguration.openshift.io/role=worker -o jsonpath="{range .items[*]}{.metadata.name} {': '}{range .spec.config.storage.files[*]}{.path} {' '}{end}{'\n'}{end}" | grep chrony
vim chrony-mod.conf
base64 -w0 chrony-mod.conf; echo
vim 99-zcustom-chrony.yml #change the base64 value
oc create -f 99-zcustom-chrony.yml
oc get mc
oc get mcp
oc get events -n openshift-machine-config-operator --sort-by='{.lastTimestamp}' --field-selector involvedObject.name=custom

oc get mcp
Get in to workernode 01 and 02 [no change] and verify the /etc/chrony.conf
Get in to worker01 manually change 0.rhel to 1.rhel
oc get mcp #degraded
oc describe mcp custom
oc get pod -n openshift-machine-config-operator --field-selector spec.nodeName=worker01
oc logs machine-config-daemon-XXXX -n openshift-machine-config-operator
Get in to worker01 and revert change
oc get mcp
oc label node/worker01 node-role.kubernetes.io/custom-
oc get nodes -l node-role.kubernetes.io/custom=
oc describe node worker01 | grep machineconfiguration #Wait
oc get mcp #Wait until updated shows true
oc delete  mc 99-zcustom-chrony
oc delete mcp custom #remove only after mco applies change to worker01
cd
lab finish nodes-mco





