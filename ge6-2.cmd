lab start monitoring-alerts
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
oc get secret/alertmanager-main -n openshift-monitoring
oc extract secret/alertmanager-main -n openshift-monitoring --to ~/DO380/labs/monitoring-alerts --confirm
sed -i -f ~/DO380/labs/monitoring-alerts/script.sed ~/DO380/labs/monitoring-alerts/alertmanager.yaml
Edit the alertmanager.yaml.Edited one in next command
vi ~/DO380/solutions/monitoring-alerts/alertmanager.yaml
oc set data secret/alertmanager-main -n openshift-monitoring --from-file ~/DO380/solutions/monitoring-alerts/alertmanager.yaml
oc logs -f statefulset.apps/alertmanager-main -c alertmanager -n openshift-monitoring
oc project monitoring-alerts
oc apply -f ~/DO380/labs/monitoring-alerts/workload.yaml
watch oc get deployments,pods #Wait til pod is running
oc whoami --show-console
Login to console as admin with redhatocp.Observe--->Alert-->Wait for alerts PersistentVolumeUsageCritical•PersistentVolumeUsageNearFull.Click the PersistentVolumeUsageNearFull
Get in to ssh lab@utility.lab.example.com. Execute mutt
Silence the PersistentVolumeUsageNearFull
lab finish monitoring-alerts




