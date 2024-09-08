lab start scheduling-selector
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc get no -L rack,cpu
oc login -u developer -p developer
vim deployment.yml
oc create -f deployment.yml
oc get deployment
oc get pods -o wide
vi deployment-ns-fastcpu.yml
oc create -f deployment-ns-fastcpu.yml
oc get deployment
oc get pods -o wide -l app=myapp-ns-fastcpu
oc login -u admin -p redhatocp
oc adm drain worker03 --ignore-daemonsets --delete-emptydir-data
oc get deployment
oc get pod -o wide
oc get events --sort-by='{.lastTimestamp}'
oc describe pod myapp-ns-fastcpu-xxxxxx
oc adm uncordon worker03
vi project-scheduling.yml
oc create -f project-scheduling.yml
oc adm policy add-role-to-user edit developer -n scheduling-ns
oc login -u developer -p developer
oc project scheduling-ns
oc describe project scheduling-ns
vi deployment-project-ns.yml
oc create -f deployment-project-ns.yml
oc get deployment
oc get pod -o wide
oc describe pod project-ns-xxxx
vi deployment-project-podsel.yml
oc create -f deployment-project-podsel.yml
oc get deployment
oc get pods -o wide -l app=project-podsel
oc describe pod project-podsel-xxxx
oc login -u admin -p redhatocp
oc adm taint nodes worker01 type=mission-critical:NoSchedule
oc adm taint nodes worker03 type=mission-critical:NoSchedule
oc describe node worker01 | grep Taints
oc describe node worker03 | grep Taints
oc login -u developer -p developer
oc new-project scheduling-taint
vi deployment-taint-fastcpu.yml
oc create -f deployment-taint-fastcpu.yml
oc get deployment
oc get pod -o wide
oc get events --sort-by='{.lastTimestamp}'
oc delete deployment myapp-taint-fastcpu
vim deployment-taint-fastcpu.yml 
oc create -f deployment-taint-fastcpu.yml
oc get deployment
oc get pod -o wide
cd
lab finish scheduling-selector
