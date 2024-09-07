lab start auth-sync
ldapsearch -D "cn=Directory Manager" -w redhatocp -H ldaps://rhds.ocp4.example.com
oc login -u kristendelgado -p redhat123 https://api.ocp4.example.com:6443
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc new-project auth-rhds-sync
oc create sa rhds-group-syncer
oc create clusterrole rhds-group-syncer --verb get,list,create,update --resource groups
oc adm policy add-cluster-role-to-user rhds-group-syncer -z rhds-group-syncer
oc create secret generic rhds-secret --from-literal bindPassword='redhatocp'
vim rhds-sync.yaml
oc create configmap rhds-config --from-file rhds-sync.yaml=rhds-sync.yaml,ca.crt=/home/student/DO380/labs/auth-sync/sync/rhds_ca.crt
vim rhds-groups-cronjob.yaml
oc create -f rhds-groups-cronjob.yaml
oc get groups
oc adm policy add-cluster-role-to-group cluster-admin administrators
oc login -u kristendelgado -p redhat123
oc auth can-i create users -A
cd
lab finish auth-sync
