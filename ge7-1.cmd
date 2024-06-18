lab start logging-forward

Login to console https://console-openshift-console.apps.ocp4.example.com as admin with password redhatocp

Install Operator->OperatorHub-->search openshiftlogging-->click Install-->Wait till-ready-for-use

oc login -u admin -p redhatocp https://api.ocp4.example.com:6443

oc project openshift-logging

vi ~/DO380/solutions/logging-forward/clusterlogging.yml

oc apply -f ~/DO380/solutions/logging-forward/clusterlogging.yml 

vim ~/DO380/solutions/logging-forward/clusterlogforwarder.yml

oc apply -f ~/DO380/solutions/logging-forward/clusterlogforwarder.yml

oc get daemonset -l component=collector

oc process -f /home/student/DO380/labs/logging-forward/eventrouter.yml | oc apply -f -

oc get pod -l component=eventrouter

Take another terminal--->login to utility---ssh root@utility

ssh root@utility ls -l /var/log/openshift/

Execute below command in one terminal and next command in another terminal

tail -f /var/log/openshift/infra.log | egrep -o "\{.*}$" | jq '. | select(.systemd.u.SYSLOG_IDENTIFIER=="sshd") | .hostname + " " + .message'

Execute in another terminal ssh core@master01.ocp4.example.com

Ctrl+C IN utility Machine

Execute in utility as root user  egrep -ho "\{.*}$" /var/log/openshift/audit.log* | jq '. | select(."audit.linux".type == "USER_LOGIN")| ."@timestamp" + " " + .hostname + " " + .message'

Execute next command--->see the output--->CTLR+C

Execute in utility as root tail -f /var/log/openshift/infra.log | egrep -o "\{.*}$" | jq '. | select(.kubernetes.namespace_name == "openshift-storage")| .kubernetes.pod_name + " " + .message'

Execute in utility as root tail -f /var/log/openshift/audit.log | egrep -o "\{.*}$" | jq -c '.|select(.user.username == "developer")| [.user.username, .annotations, .verb, .objectRef]'

Execute next command here --->Login ,create project[oc login -u developer -p developer https://api.ocp4.example.com:6443 ,oc new-project logger-app] in another terminal-->see--CTRL+c

Execute in utility as root  tail -f /var/log/openshift/infra.log | egrep -o "\{.*}$" | jq -c '.| select(.kubernetes.event.involvedObject.namespace == "logger-app")| [.kubernetes.event.involvedObject.kind,.kubernetes.event.involvedObject.name, .message]'

Execute next command --->Execute [oc apply -f ~/DO380/labs/logging-forward/logger.yml] in another terminal-->CTRL+c

Execute in utility as root  grep -m1 shop-web /var/log/openshift/apps.log | egrep -o "\{.*}" | jq

Execute in utility as  root grep logger-app /var/log/openshift/apps.log

oc login -u admin -p redhatocp https://api.ocp4.example.com:6443

oc delete project logger-app

oc -n openshift-logging delete clusterlogging,clusterlogforwarder --all

oc -n openshift-logging delete deployment eventrouter

lab finish logging-forward
