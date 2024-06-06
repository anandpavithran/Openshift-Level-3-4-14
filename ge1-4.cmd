lab start auth-conflict
oc login -u abbyquincy -p redhat_htpasswd https://api.ocp4.example.com:6443 #Wait if fails
oc login -u abbyquincy -p redhat_htpasswd https://api.ocp4.example.com:6443 #Wait if fails
oc login -u admin -p redhatocp
oc get users
oc login -u abbyquincy -p redhat_sso
oc get pods -n openshift-authentication
oc logs oauth-openshift-XXXXXXXXX -n openshift-authentication #FROM PREVIOUS OUTPUT
vi /home/student/DO380/labs/auth-conflict/oauth_config.yml
oc apply -f ~/DO380/labs/auth-conflict/oauth_config.yml
watch oc get pods -n openshift-authentication
oc login -u abbyquincy -p redhat_sso
lab finish auth-conflict

