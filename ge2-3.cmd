lab start backup-restore
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc project database
oc get pvc,svc,deployment,secret,configmap -l app=mariadb
oc get namespace database -oyaml
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb -u ${MARIADB_USER} -p"${MARIADB_PASSWORD}" ${MARIADB_DATABASE} -te "select * from application_logs order by id desc LIMIT 5;"'
vim backup-db-manual.yml
oc apply -f backup-db-manual.yml
cat velero
sudo cp velero /usr/local/bin/
alias velero='oc -n openshift-adp exec deployment/velero -c velero -it -- ./velero' Show by othermethod
#EXECUTE VELERO COMMAND IN OTHER TERMINAL
#velero get backup db-manual
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb -u ${MARIADB_USER} -p"${MARIADB_PASSWORD}" ${MARIADB_DATABASE} -te "select * from application_logs where time <= \"REPLACETIME\" order by id desc LIMIT 5;"
vi restore-db-crash.yml
oc apply -f restore-db-crash.yml
#velero get restore db-crash
oc project database-crash
oc get pvc,svc,deployment,secret,configmap -l app=mariadb
oc get namespace database-crash -oyaml
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb-check -u root -p"${MARIADB_ROOT_PASSWORD}" -A --auto-repair'
sh /home/student/DO380/labs/backup-restore/view-db.sh
s3cmd la -r ~/DO380/labs/backup-restore
#velero delete backup db-manual
#velero get backup db-manual
oc -n openshift-adp get backup,restore
s3cmd la -r ~/DO380/labs/backup-restore
s3cmd ls
s3cmd la -r
vi schedule-db-backup.yml
oc apply -f schedule-db-backup.yml
#velero get schedule
#velero create backup --from-schedule=db-backup
#Use other terminal for next command .After next command,use ctrl +c to exit from watch command
watch -n 10 oc -n openshift-adp exec deployment/velero -c velero -it -- ./velero get backup -l velero.io/schedule-name=db-backup
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb -u ${MARIADB_USER} -p"${MARIADB_PASSWORD}" ${MARIADB_DATABASE} -te "select * from application_logs where time <= \"REPLACETIME\" order by id desc LIMIT 5;"'
vi restore-db-backup.yml #change the backupname
oc apply -f restore-db-backup.yml
#velero get restore db-backup
oc project database-backup
oc exec -c mariadb deploy/mariadb -- bash -c 'mariadb-check -u root -p"${MARIADB_ROOT_PASSWORD}" -A'
oc exec -n database-backup deploy/mariadb -c mariadb -- bash -c 'mariadb -u ${MARIADB_USER} -p"${MARIADB_PASSWORD}" ${MARIADB_DATABASE} -te "select * from application_logs order by id desc LIMIT 5;"'
oc delete project database-crash database-backup
#velero delete backup -l velero.io/schedule-name=db-backup
lab finish backup-restore
