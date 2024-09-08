lab start scheduling-pdb
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc get nodes -L rack
oc login -u developer -p developer
vim deployment.yaml
oc apply -f deployment.yaml
#In new terminal window and continue #watch oc get pdb,deployments,pods -o wide
#In other terminal #sh /DO380/labs/scheduling-pdb/count-pods.sh
oc login -u admin -p redhatocp
oc adm drain node/worker01 --ignore-daemonsets --delete-emptydir-data # watch in other terminal
oc get nodes
#In other terminal #sh /DO380/labs/scheduling-pdb/count-pods.sh
oc delete deployment/nginx
oc adm uncordon node/worker01
oc get nodes -L rack
oc login -u developer -p developer
vim deployment-affinity.yaml
oc apply -f deployment-affinity.yaml #watch in other terminal
#In other terminal #sh /DO380/labs/scheduling-pdb/count-pods.sh
vi pod-disruption-budget.yaml
oc apply -f pod-disruption-budget.yaml
oc describe pdb nginx
oc login -u admin -p redhatocp
oc adm drain node/worker03 --ignore-daemonsets --delete-emptydir-data #Watch in other terminal
oc get nodes
#In other terminal #sh /DO380/labs/scheduling-pdb/count-pods.sh
lab finish scheduling-pdb







