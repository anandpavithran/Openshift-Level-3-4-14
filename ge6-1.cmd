lab start monitoring-cluster
sh ~/DO380/labs/monitoring-cluster/traffic-simulator.sh
Go to cosole https://console-openshift-console.apps.ocp4.example.com as admin -  redhatocp-->Observer-->Dashboards-->Kubernetes / Compute Resources / Cluster-->CPU Quota--> CPU Usage
Check dev-monitor and dev-finance namespaces are likely listed among the five namespaces,also for dev-monitor more than 100% use-->if not refresh
Memory Request-->Memory Usage-->dev-monitor namespace is likely listed among the five namespaces-->more than 350MB-->more than 100%
Kubernetes / Compute Resources / Namespace (Workloads) dashboard-->CPU Quota-->--see the details-->Memory Usage
Kill the script
Firefox- http://budget-test-monitor.apps.ocp4.example.com
Firefox- http://frontend-test-monitor.apps.ocp4.example.com
Console-->Observe-->Dashboard-->Kubernetes /Compute Resources / Namespace (Workloads)-->test-monitor namespace-->check cpu usage,memory,network-->Node Cluster-->NotReadyNodesCount-->Inspect-->NotReadyNodesCount
Query to identify node  kube_node_status_condition{condition="Ready", status=~"unknown|false"} == 1
lab finish monitoring-cluster






