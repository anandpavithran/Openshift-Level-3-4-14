lab start gitops-admin
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc whoami --show-console
Login to console as admin with redhatocp.OperatorHUb-->RedhatOPenshiftGitOps-->Install-->ViewOPerator--Go to next step
Take other terminal Login to https://openshift-gitops-server-openshift-gitops.apps.ocp4.example.com Argo CD-->Click instance in the openshift-gitops-->YAML-->Remove the ownerReferences key from the metadata key-->In route tls: termination: reencrypt --->SAVE-->RELOAD-->Add rbac:-->policy: |-->g, ocpadmins, role:admin-->Save
oc create configmap -n openshift-gitops cluster-root-ca-bundle
oc label configmap -n openshift-gitops cluster-root-ca-bundle config.openshift.io/inject-trusted-cabundle=true
oc edit argocd -n openshift-gitops openshift-gitops # Add details
Login https://git.ocp4.example.com as developer user with d3v3lop3r--->Newproject-->CReate blank project-->reponame[gitops-admin]-->Publicvisibility-->all default-->CReate project-->Clone-->https://git.ocp4.example.com/developer/gitops-admin.git
git clone -C ~/DO380/labs/gitops-admin https://git.ocp4.example.com/developer/gitops-admin.git
cp ~/DO380/labs/gitops-admin/operator.yaml ~/DO380/labs/gitops-admin/gitops-admin/operator.yaml
vi ~/DO380/labs/gitops-admin/gitops-admin/operator.yaml #Add to lines below  annotationargocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true argocd.argoproj.io/sync-wave: "1"
git add ~/DO380/labs/gitops-admin/gitops-admin/operator.yaml
git commit -C ~/DO380/labs/gitops-admin/gitops-admin -m "Add compliance manifests"
git push -C ~/DO380/labs/gitops-admin/gitops-admin/
#Login to ARGOCD firefoxtab-->login via OPENSHIFT-->LOgin with admin and redhatocp-->Go to next step
CREATE APPLICATION-->FILL-->CREATE-->Go to next step
Synchronize--Click gitops-admin-->click SYNCHRONIZE-->Wait till it completes-->click nist-moderate-->Go to next step
watch oc get compliancesuite -A # CTRL+C
cp ~/DO380/labs/gitops-admin/console.yaml ~/DO380/labs/gitops-admin/gitops-admin/console.yaml
vi ~/DO380/labs/gitops-admin/gitops-admin/console.yaml #Add in annotation argocd.argoproj.io/sync-options: ServerSideApply=true,Validate=false #Add in spec customProductName: Production
git add ~/DO380/labs/gitops-admin/gitops-admin/console.yaml
git commit -C ~/DO380/labs/gitops-admin/gitops-admin -m "Customize console"
git push -C ~/DO380/labs/gitops-admin/gitops-admin/
Click SYNC-->Refresh console -->see label Production
lab finish gitops-admin











