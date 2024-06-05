lab start backup-oadp
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc whoami --show-console
oc get all -n openshift-operators
oc project openshift-adp
vim ~/DO380/labs/backup-oadp/obc-backup.yml 
oc get obc
oc apply -f  ~/DO380/labs/backup-oadp/obc-backup.yml 
oc get obc
oc extract --to=- cm/backup 
oc get cm/openshift-service-ca.crt -o jsonpath='{.data.service-ca\.crt}' | base64 -w0; echo
oc extract --to=- secret/backup
oc get route s3 -n openshift-storage
vim ~/.s3cfg
s3cmd la
vim ~/DO380/labs/backup-oadp/dpa-backup.yml 
vim ~/DO380/labs/backup-oadp/cloud-credentials 
oc create secret generic cloud-credentials -n openshift-adp --from-file cloud=~/DO380/labs/backup-oadp/cloud-credentials 
oc create secret generic restic-enc-key -n openshift-adp --from-literal=RESTIC_PASSWORD=$(openssl rand -base64 24)
oc get deploy -n openshift-adp
oc apply -f ~/DO380/labs/backup-oadp/dpa-backup.yml 
oc get dpa
oc get backupStorageLocation
