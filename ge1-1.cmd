lab start auth-ldap
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc whoami --show-console
Continue in console
ldapsearch -D "cn=Directory Manager" -w redhatocp -H ldaps://rhds.ocp4.example.com
Continue on console
cat /home/student/DO380/labs/auth-ldap/rhds_ca.crt
lab finish auth-ldap
