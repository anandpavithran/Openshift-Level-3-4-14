lab start backup-export
oc login -u developer -p developer https://api.ocp4.example.com:6443
oc get all
cd ~/DO380/labs/backup-export/
mkdir ~/DO380/labs/backup-export/production
ls ~/DO380/labs/backup-export/
oc get pvc etherpad -o yaml | yq d - metadata.annotations | yq d - metadata.creationTimestamp | yq d - metadata.namespace | yq d - metadata.finalizers | yq d - metadata.resourceVersion | yq d - metadata.uid | yq d - spec.volumeName | yq d - status > ~/DO380/labs/backup-export/production/01-pvc.yml
cat ~/DO380/labs/backup-export/production/01-pvc.yml 
oc get deploy etherpad -o yaml | yq d - metadata.annotations | yq d - metadata.creationTimestamp | yq d - metadata.namespace | yq d - metadata.resourceVersion | yq d - metadata.uid | yq d - metadata.generation | yq d - status > ~/DO380/labs/backup-export/production/02-deployment.yml
cat ~/DO380/labs/backup-export/production/02-deployment.yml 
oc get svc etherpad -o yaml | yq d - metadata.annotations | yq d - metadata.creationTimestamp | yq d - metadata.namespace | yq d - metadata.resourceVersion | yq d - metadata.uid | yq d - spec.clusterIP* | yq d - status > ~/DO380/labs/backup-export/production/03-service.yml
cat ~/DO380/labs/backup-export/production/03-service.yml 
oc get route etherpad -o yaml | yq d - metadata.annotations | yq d - metadata.creationTimestamp | yq d - metadata.namespace | yq d - metadata.resourceVersion | yq d - metadata.uid | yq d - spec.host | yq d - status > ~/DO380/labs/backup-export/production/04-route.yml
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc edit configs.imageregistry.operator.openshift.io/cluster
watch -n10 oc get co openshift-apiserver
oc login -u developer -p developer https://api.ocp4.example.com:6443
oc registry login
oc get is etherpad --template '{{.status.publicDockerImageRepository}}'
IMAGE=$(oc get is etherpad --template '{{.status.publicDockerImageRepository}}')
echo $IMAGE
ls ~/DO380/labs/backup-export/production/
oc image mirror $IMAGE file://etherpad --dir=/home/student/DO380/labs/backup-export/production
ls ~/DO380/labs/backup-export/production/v2/
ls ~/DO380/labs/backup-export/production/v2/etherpad/
oc get pvc
oc get sc ocs-external-storagecluster-ceph-rbd
oc get volumesnapshotclasses | egrep "^NAME|openshift-storage.rbd.csi.ceph.com"
oc scale deploy/etherpad --replicas 0
oc get pod
oc get volumesnapshot
oc apply -f ~/DO380/solutions/backup-export/volumesnapshot-etherpad.yml 
oc get volumesnapshot
oc scale deploy/etherpad --replicas 1
oc get pvc
oc apply -f ~/DO380/solutions/backup-export/pvc-snapshot.yml 
oc get pvc
oc get pod
oc apply -f ~/DO380/solutions/backup-export/pod-snapshot.yml 
oc get pod
oc cp export-snapshot:/snapshot  ~/DO380/labs/backup-export/production/data
tree ~/DO380/labs/backup-export/production/
oc delete pod/export-snapshot 
oc new-project stage
oc image mirror --dir=/home/student/DO380/labs/backup-export/production file://etherpad default-route-openshift-image-registry.apps.ocp4.example.com/stage/etherpad
oc get is
oc apply -n stage -f ~/DO380/labs/backup-export/production/01-pvc.yml 
oc get pvc
oc project
oc get pod
oc apply -f ~/DO380/solutions/backup-export/pod-restore.yml 
oc get pod
oc rsync --no-perms ~/DO380/labs/backup-export/production/data/ restore-snapshot:/data/
oc exec restore-snapshot -- ls -1 /data
oc delete pod/restore-snapshot 
cp ~/DO380/labs/backup-export/production/02-deployment.yml ~/DO380/labs/backup-export/stage-deployment.yml
vim ~/DO380/labs/backup-export/stage-deployment.yml 
oc apply -n stage -f ~/DO380/labs/backup-export/stage-deployment.yml 
oc apply -n stage -f ~/DO380/labs/backup-export/production/03-service.yml 
oc apply -n stage -f ~/DO380/labs/backup-export/production/04-route.yml 
oc get all
cd
oc login -u admin -p redhatocp
oc edit configs.imageregistry.operator.openshift.io/cluster
oc delete project stage
lab finish backup-export 
