lab start auth-oidc
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc project auth-oidc
oc adm policy add-role-to-group edit contractors
oc adm policy add-role-to-group view partners
Do in other terminal  ssh rhsso@sso.ocp4.example.com
ON SSO /opt/rh-sso-7.6/bin/kcadm.sh config credentials --server https://sso.ocp4.example.com:8080/auth --user admin --password redhatocp --realm master
ON SSO /opt/rh-sso-7.6/bin/kcadm.sh get users -r external_providers --fields 'id,username'
ON SSO /opt/rh-sso-7.6/bin/kcadm.sh get groups -r external_providers --fields 'id,name'
ON SSO/opt/rh-sso-7.6/bin/kcadm.sh get users/a175e1b7-6210-40f8-aeda-732021142e84/groups -r external_providers
ON SSO /opt/rh-sso-7.6/bin/kcadm.sh get clients -r external_providers -q clientId=ocp_rhsso
ON SSO /opt/rh-sso-7.6/bin/kcadm.sh get clients/f57e9ddc-8c60-4b40-8048-ec0120595be2/installation/providers/keycloak-oidc-keycloak-json -r external_providers > rhsso.json
ON SSO cat rhsso.json
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc create secret generic rhsso-oidc-client-secret --from-literal clientSecret=FILLSECRET-taken-from-SSO -n openshift-config
vi /home/student/DO380/labs/auth-oidc/sso_config.yml
oc apply -f ~/DO380/labs/auth-oidc/sso_config.yml
oc get pods -n openshift-authentication #wait
oc get pods -n openshift-authentication #wait
oc get pods -n openshift-authentication #wait
oc login -u abbyquincy -p redhat_sso
oc run ubi9-date --restart 'Never' --image registry.ocp4.example.com:8443/ubi9/ubi -- date
oc get pods
oc get users
oc login -u admin -p redhatocp
oc get groups
oc login -u jayalamont -p redhat_sso
oc get pod
oc delete pod ubi9-date
LOGIN AS fricisritcher with pass redhat_sso in CONSOLE
oc login -u admin -p redhatocp
oc get users #NOTE the id of fricisritcher
oc get groups
TO SSO ssh rhsso@sso.ocp4.example.com
ON SSO /opt/rh-sso-7.6/bin/kcadm.sh config credentials --server https://sso.ocp4.example.com:8080/auth --user admin --password redhatocp --realm master
ON SSO /opt/rh-sso-7.6/bin/kcadm.sh delete users/958fde0c-360c-48f8-b5e5-942708fbb36e /groups/e92319be-d5df-4a0c-833a-687fd25ca34c -r external_providers #CHECK ID OF USER
EXIT FROM SSO
oc get groups
LOGIN AS fricisritcher with pass redhat_sso in CONSOLE try to remove ubi9-date
pod .Should be possible.Not synchronized.LOGOUT.LOGIN.LOGOUT as fricist user
oc get groups
TO SSO ssh rhsso@sso.ocp4.example.com 
ON SSO /opt/rh-sso-7.6/bin/kcadm.sh config credentials --server https://sso.ocp4.example.com:8080/auth --user admin --password redhatocp --realm master
/opt/rh-sso-7.6/bin/kcadm.sh delete users/958fde0c-360c-48f8-b5e5-942708fbb36e -r external_providers  # CHECK ID OF USER
FROM CONSOLE as fricisritcher create project and pod.It will work
User still has access token 
oc get oauthaccesstoken
oc delete oauthaccesstoken $(oc get oauthaccesstoken -o jsonpath='{.items[?(@.userName=="fricisritcher")].metadata.name}')
WAIT IN FIREFOX until OpenShift automatically logs out the user.
oc get users
oc delete user fricisritcher
oc delete identity id-taken-from-get user-command




