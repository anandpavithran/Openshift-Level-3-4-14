lab start logging-central
Take console https://console-openshift-console.apps.ocp4.example.com login using admin and redhatocp
OperatorHub-->install Loki Operator
Enable Operator recommended cluster monitoring on this Namespace-->install
vi ~/DO380/labs/logging-central/objectbucket.yaml
oc create -f ~/DO380/labs/logging-central/objectbucket.yaml
oc get obc -n openshift-logging
BUCKET_HOST=$(oc get -n openshift-logging configmap loki-bucket-odf -o jsonpath='{.data.BUCKET_HOST}')
BUCKET_NAME=$(oc get -n openshift-logging configmap loki-bucket-odf -o jsonpath='{.data.BUCKET_NAME}');
BUCKET_PORT=$(oc get -n openshift-logging configmap loki-bucket-odf -o jsonpath='{.data.BUCKET_PORT}'); 
ACCESS_KEY_ID=$(oc get -n openshift-logging secret loki-bucket-odf -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 -d);
SECRET_ACCESS_KEY=$(oc get -n openshift-logging secret loki-bucket-odf -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 -d)
oc create secret generic logging-loki-odf -n openshift-logging --from-literal=access_key_id=${ACCESS_KEY_ID} --from-literal=access_key_secret=${SECRET_ACCESS_KEY} --from-literal=bucketnames=${BUCKET_NAME} --from-literal=endpoint=https://${BUCKET_HOST}:${BUCKET_PORT}
vi ~/DO380/labs/logging-central/lokistack.yaml
oc create -f ~/DO380/labs/logging-central/lokistack.yaml
oc get pods -n openshift-logging
vi ~/DO380/labs/logging-central/clusterlogging.yaml
oc create -f ~/DO380/labs/logging-central/clusterlogging.yaml
oc get pods -n openshift-logging
Enable console plug-in Operators-->Install Operator-->All projects-->REDHAT OPENSHIFT LOGGING-->CONSOLE PLUGIN-->ENABLE--SAVE-->RELOAD[F5]-->OBSERVE-->LOGS-->"Message:no datapoints"-->enabledata forwarder
vi ~/DO380/labs/logging-central/forwarder.yaml
oc create -f ~/DO380/labs/logging-central/forwarder.yaml
ssh worker01.ocp4.example.com --> check for result in console--> Click in Show Query and Modify Query { log_type="infrastructure" } | json | systemd_u_SYSLOG_IDENTIFIER="sshd"
oc login -u developer -p developer
oc new-project testing-logs
oc run test-date --restart 'Never' --image registry.ocp4.example.com:8443/ubi9/ubi -- date
oc get pods
oc logs test-date
oc delete pod test-date
oc logs test-date
Login as developer https://console-openshift-console.apps.ocp4.example.com--->testing-logs project--> Observe-->Logs--See Forbidden
Login as admin -->modify query filter --->{ log_type="application", kubernetes_namespace_name="testing-logs" } | json -->Runquery
oc login -u admin -p redhatocp
vi ~/DO380/labs/logging-central/developer-role.yaml
oc create -f ~/DO380/labs/logging-central/developer-role.yaml
LOgin as developer --> see the logs
lab finish logging-central




