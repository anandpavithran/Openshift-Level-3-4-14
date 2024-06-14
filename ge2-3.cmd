lab start backup-restore
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc project database
oc get pvc,svc,deployment,secret,configmap -l app=mariadb
oc get namespace database -oyaml
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb -u ${MARIADB_USER} -p"${MARIADB_PASSWORD}" ${MARIADB_DATABASE} -te "select * from application_logs order by id desc LIMIT 5;"'
vim ~/DO380/labs/backup-restore/backup-db-manual.yml
oc apply -f ~/DO380/labs/backup-restore/backup-db-manual.yml
alias velero='oc -n openshift-adp exec deployment/velero -c velero -it -- ./velero'
velero get backup db-manual
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb -u ${MARIADB_USER} -p"${MARIADB_PASSWORD}" ${MARIADB_DATABASE} -te "select * from application_logs where time <= \"2023-12-04 12:16:40\" order by id desc LIMIT 5;"
vi ~/DO380/labs/backup-restore/restore-db-crash.yml
oc apply -f ~/DO380/labs/backup-restore/restore-db-crash.yml
velero get restore db-crash
oc project database-crash
oc get pvc,svc,deployment,secret,configmap -l app=mariadb
oc get namespace database-crash -oyaml
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb-check -u root -p"${MARIADB_ROOT_PASSWORD}" -A --auto-repair'
s3cmd la -r ~/DO380/labs/backup-restore
velero delete backup db-manual
velero get backup db-manual
oc -n openshift-adp get backup,restore
s3cmd la -r ~/DO380/labs/backup-restore 
oc get -l velero.io/restore-name=db-crash VolumeSnapshotContent,VolumeSnapshot -A
oc delete -l velero.io/restore-name=db-crash VolumeSnapshotContent,VolumeSnapshot -A
s3cmd ls
s3cmd rm -r \s3://USE-THE-NAME/openshift-adp/db-manual/
vi ~/DO380/labs/backup-restore/schedule-db-backup.yml
oc apply -f ~/DO380/labs/backup-restore/schedule-db-backup.yml
velero get schedule
velero create backup --from-schedule=db-backup
#After next command,use ctrl +c to exit from watch command
watch -n 10 oc -n openshift-adp exec deployment/velero -c velero -it -- ./velero get backup -l velero.io/schedule-name=db-backup
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb -u ${MARIADB_USER} -p"${MARIADB_PASSWORD}" ${MARIADB_DATABASE} -te "select * from application_logs where time <= \"2023-12-04 12:16:40\" order by id desc LIMIT 5;"
vi ~/DO380/labs/backup-restore/restore-db-backup.yml
oc apply -f ~/DO380/labs/backup-restore/restore-db-backup.yml
velero get restore db-backup
oc delete -l velero.io/restore-name=db-backup VolumeSnapshotContent,VolumeSnapshot -A
oc project database-backup
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb-check -u root -p"${MARIADB_ROOT_PASSWORD}" -A'
oc exec -n database-backup deploy/mariadb -c mariadb -- bash -c 'mariadb -u ${MARIADB_USER} -p"${MARIADB_PASSWORD}" ${MARIADB_DATABASE} -te "select * from application_logs order by id desc LIMIT 5;"'
oc delete project database-crash database-backup
velero delete backup -l velero.io/schedule-name=db-backup





