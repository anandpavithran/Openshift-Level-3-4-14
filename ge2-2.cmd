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
oc get cm/openshift-service-ca.crt -o jsonpath='{.data.service-ca\.crt}' | base64 -w0; echo #EXECUTE IN OTHER TERMINAL
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
oc get deploy -n openshift-adp
oc get backupStorageLocation
oc get volumesnapshotclass
for class in  $(oc get volumesnapshotclass -oname); do oc patch $class --type=merge -p '{"deletionPolicy": "Retain"}';done
oc label volumesnapshotclass velero.io/csi-volumesnapshot-class="true" --all
vim ~/DO380/labs/backup-oadp/backup.yml
oc apply -f  ~/DO380/labs/backup-oadp/backup.yml
oc describe backup backup-production
s3cmd la -r
cd
oc get all
oc exec deployment/velero -c velero -it -- ./velero delete backup backup-production
oc get backup
s3cmd rm -r --force s3://backup-7ebc6ea6-be7c-449b-aaa1-25b3d50ac2ab/
lab finish backup-oadp
