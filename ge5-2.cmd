lab start gitops-app
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc project gitops-app
oc create configmap cluster-root-ca-bundle
oc label configmap cluster-root-ca-bundle config.openshift.io/inject-trusted-cabundle=true
vi ~/DO380/labs/gitops-app/argocd-instance.yaml
oc create -f ~/DO380/labs/gitops-app/argocd-instance.yaml
oc new-project etherpad-devs
oc label namespace etherpad-devs argocd.argoproj.io/managed-by=gitops-app
oc adm policy add-role-to-group admin project-admins -n etherpad-devs
oc login -u developer -p developer
oc projects
oc login -u project-admin -p redhat
vi ~/DO380/labs/gitops-app/secret.yaml
oc create -f ~/DO380/labs/gitops-app/secret.yaml
vi ~/DO380/labs/gitops-app/etherpad-admin/rbac.yaml
Browser https://git.ocp4.example.com. Log in as the project-admin user with r3dh4tgit--->CLICK etherpad-admin-->Upload	~/DO380/labs/gitops-app/etherpad-admin/rbac.yaml-->open-->upload
oc login -u admin -p redhatocp
oc get route -n gitops-app
Browser https://argocd-server-gitops-app.apps.ocp4.example.com-->via openshift-->Log in as the project-admin user with redhat-->Create Application-->fill-->CREATE
oc login -u developer -p developer
Browser ARGOCD -->Click NEW APP-->FILL-->CREATE-->CLICK etherpad-app
oc get route
Browser https://etherpad-etherpad-devs.apps.ocp4.example.com
cp ~/DO380/labs/gitops-app/hooks/{presync,postsync}.yaml ~/DO380/labs/gitops-app/etherpad-app/
vim ~/DO380/labs/gitops-app/etherpad-app/presync.yaml
vim ~/DO380/labs/gitops-app/etherpad-app/postsync.yaml
vim ~/DO380/labs/gitops-app/etherpad-app/etherpad-deployment.yaml
git add ~/DO380/labs/gitops-app/etherpad-app/presync.yaml ~/DO380/labs/gitops-app/etherpad-app/postsync.yaml ~/DO380/labs/gitops-app/etherpad-app/etherpad-deployment.yaml
git commit -C ~/DO380/labs/gitops-app/etherpad-app -m "Add synchronization hooks and change title"
git push -C ~/DO380/labs/gitops-app/etherpad-app/
Browser ARGOCD -->Login as developer with developer-->Click etherpad-app-->check syncing
oc login -u project-admin -p redhat
oc create -f ~/DO380/labs/gitops-app/backup-inspector.yaml
oc rsh backup-inspector ls /external-data/
oc delete pod backup-inspector
Browser refresh https://etherpad-etherpad-devs.apps.ocp4.example.com
lab finish gitops-app




