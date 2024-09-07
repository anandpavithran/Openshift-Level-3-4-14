lab start auth-tls
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc project auth-tls
oc create sa health-robot
oc adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:auth-tls:health-robot
HEALTHROBOT_TOKEN=$(oc create token -n auth-tls health-robot --duration 604800s)
oc config set-credentials health-robot --token $HEALTHROBOT_TOKEN --kubeconfig ~/DO380/labs/auth-tls/robot-cert/health-robot.config
oc config set-cluster $(oc config view -o jsonpath='{.clusters[0].name}') --server https://api.ocp4.example.com:6443 --kubeconfig ~/DO380/labs/auth-tls/robot-cert/health-robot.config
oc config set-context health-robot --cluster $(oc config view -o jsonpath='{.clusters[0].name}') --namespace auth-tls --user health-robot --kubeconfig ~/DO380/labs/auth-tls/robot-cert/health-robot.config
oc config use-context health-robot --kubeconfig ~/DO380/labs/auth-tls/robot-cert/health-robot.config
oc whoami --kubeconfig ~/DO380/labs/auth-tls/robot-cert/health-robot.config
oc auth can-i get users -A --as system:serviceaccount:auth-tls:health-robot
oc auth can-i create project -A --as system:serviceaccount:auth-tls:health-robot
oc auth can-i get pods -A --as system:serviceaccount:auth-tls:health-robot
sh ~/DO380/labs/auth-tls/cluster-health.sh
Insert * * * * * /home/student/DO380/labs/auth-tls/cluster-health.sh
crontab -e
oc run failing-pod --image registry.ocp4.example.com:8443/failing-pod
Wait for few minutes cat /tmp/cluster.log
oc adm groups new backdoor-administrators
oc adm policy add-cluster-role-to-group cluster-admin backdoor-administrators
mkdir ~/DO380/labs/auth-tls/admin-cert
openssl req -newkey rsa:4096 -nodes -keyout  /home/student/DO380/labs/auth-tls/tls.key -subj "/O=backdoor-administrators/CN=admin-backdoor" -out ~/DO380/labs/auth-tls/admin-cert/admin-backdoor-auth.csr
cat admin-backdoor-csr.yaml # Change "request" line# use the command in admin-backdoor-cs.yaml-bkp
oc create -f admin-backdoor-csr.yaml
oc get csr admin-backdoor-access
oc adm certificate approve admin-backdoor-access
oc get csr admin-backdoor-access
oc get csr admin-backdoor-access -o jsonpath='{.status.certificate}' | base64 -d > ~/DO380/labs/auth-tls/admin-cert/admin-backdoor-access.crt
oc config set-credentials admin-backdoor --client-certificate ~/DO380/labs/auth-tls/admin-cert/admin-backdoor-access.crt --client-key ~/DO380/labs/auth-tls/tls.key --embed-certs --kubeconfig ~/DO380/labs/auth-tls/admin-cert/admin-backdoor.config
openssl s_client -showcerts -connect api.ocp4.example.com:6443 </dev/null 2>/dev/null|openssl x509 -outform PEM > ~/DO380/labs/auth-tls/ocp-apiserver-cert.crt
oc config set-cluster $(oc config view -o jsonpath='{.clusters[0].name}') --certificate-authority ~/DO380/labs/auth-tls/ocp-apiserver-cert.crt --embed-certs=true --server https://api.ocp4.example.com:6443 --kubeconfig ~/DO380/labs/auth-tls/admin-cert/admin-backdoor.config
oc config set-context admin-backdoor --cluster $(oc config view -o jsonpath='{.clusters[0].name}') --namespace default --user admin-backdoor --kubeconfig ~/DO380/labs/auth-tls/admin-cert/admin-backdoor.config
oc config use-context admin-backdoor --kubeconfig ~/DO380/labs/auth-tls/admin-cert/admin-backdoor.config
oc whoami --kubeconfig ~/DO380/labs/auth-tls/admin-cert/admin-backdoor.config
oc auth can-i get users -A --as admin-backdoor --as-group backdoor-administrators
oc auth can-i create users -A --as admin-backdoor --as-group backdoor-administrators
oc auth can-i create project -A --as admin-backdoor --as-group backdoor-administrators
cd
lab finish auth-tls


