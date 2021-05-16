---
layout: post
title: K8s tips - logging and monitoring
categories: devops
tags: devops
---

# Monitor and output logs to a lile in Kubernetes

```
kubectl get pods --all-namespaces
kubectl logs <pod_name> -n <namespace_name>
kubectl logs <pod_name> -n <namespace_name> > output.log
```

# Configuring Prometheus to Use Service Discovery

```
::::::::::::::
clusterRole.yml
::::::::::::::
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources:
  - nodes
  - nodes/proxy
  - services
  - endpoints
  - pods
  verbs: ["get", "list", "watch"]
- apiGroups:
  - extensions
  resources:
  - ingresses
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: default
  namespace: monitoring
::::::::::::::
kube-state-metrics.yml
::::::::::::::
apiVersion: v1
kind: Service
metadata:
  name: kube-state-metrics
  namespace: monitoring
  labels:
    app: kube-state-metrics
  annotations:
    prometheus.io/scrape: 'true'
spec:
  ports:
  - name: metrics
    port: 8080
    targetPort: metrics
    protocol: TCP
  selector:
    app: kube-state-metrics
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: kube-state-metrics
  namespace: monitoring
  labels:
    app: kube-state-metrics
spec:
  replicas: 1
  template:
    metadata:
      name: kube-state-metrics-main
      labels:
        app: kube-state-metrics
    spec:
      containers:
        - name: kube-state-metrics
          image: quay.io/coreos/kube-state-metrics:latest
          ports:
          - containerPort: 8080
            name: metrics
::::::::::::::
namespaces.yml
::::::::::::::
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "monitoring",
    "labels": {
      "name": "monitoring"
    }
  }
}
::::::::::::::
prometheus-config-map.yml
::::::::::::::
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-server-conf
  labels:
    name: prometheus-server-conf
  namespace: monitoring
data:
  prometheus.yml: |-
    global:
      scrape_interval: 5s
      evaluation_interval: 5s

    scrape_configs:
      - job_name: 'kubernetes-apiservers'

        kubernetes_sd_configs:
        - role: endpoints
        scheme: https

        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        relabel_configs:
        - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
          action: keep
          regex: default;kubernetes;https

      - job_name: 'kubernetes-cadvisor'

        scheme: https

        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        kubernetes_sd_configs:
        - role: node

        relabel_configs:
        - action: labelmap
          regex: __meta_kubernetes_node_label_(.+)
        - target_label: __address__
          replacement: kubernetes.default.svc:443
        - source_labels: [__meta_kubernetes_node_name]
          regex: (.+)
          target_label: __metrics_path__
          replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
::::::::::::::
prometheus-deployment.yml
::::::::::::::
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: prometheus-deployment
  namespace: monitoring
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: prometheus-server
    spec:
      containers:
        - name: prometheus
          image: prom/prometheus:v2.2.1
          args:
            - "--config.file=/etc/prometheus/prometheus.yml"
            - "--storage.tsdb.path=/prometheus/"
            - "--web.enable-lifecycle"
          ports:
            - containerPort: 9090
          volumeMounts:
            - name: prometheus-config-volume
              mountPath: /etc/prometheus/
            - name: prometheus-storage-volume
              mountPath: /prometheus/
      volumes:
        - name: prometheus-config-volume
          configMap:
            defaultMode: 420
            name: prometheus-server-conf

        - name: prometheus-storage-volume
          emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus-service
  namespace: monitoring
  annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/port:   '9090'

spec:
  selector:
    app: prometheus-server
  type: NodePort
  ports:
    - port: 8080
      targetPort: 9090
      nodePort: 8080

kubectl apply -f clusterRole.yml
kubectl apply -f namespaces.yml
kubectl apply -f prometheus-config-map.yml
kubectl apply -f prometheus-deployment.yml
kubectl apply -f kube-state-metrics.yml

kubectl get pods -n monitoring
kubectl delete pods prometheus-deployment-84697b66db-xbmck -n monitoring

curl http://34.227.26.201:8080/targets
```

# Creating Alerting Rules

```
::::::::::::::
alertmanager-configmap.yml
::::::::::::::
apiVersion: v1
kind: ConfigMap
metadata:
  name: alertmanager-conf
  labels:
    name: alertmanager-conf
  namespace: monitoring
data:
  alertmanager.yml: |
    global:
      smtp_smarthost: 'localhost:25'
      smtp_from: 'alertmanager@linuxacademy.org'
      smtp_require_tls: false
    route:
      receiver: slack_receiver
    receivers:
    - name: slack_receiver
      slack_configs:
      - send_resolved: true
        username: '<SLACK_USER>'
        api_url: '<APP_URL>'
        channel: '#<CHANNEL>'
::::::::::::::
alertmanager-depoloyment.yml
::::::::::::::
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: alertmanager
  namespace: monitoring
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: alertmanager
    spec:
      containers:
      - name: prometheus-alertmanager
        image: prom/alertmanager:v0.14.0
        args:
          - --config.file=/etc/config/alertmanager.yml
          - --storage.path=/data
          - --web.external-url=/
        ports:
          - containerPort: 9093
        volumeMounts:
          - mountPath: /etc/config
            name: config-volume
          - mountPath: /data
            name: storage-volume
      volumes:
        - configMap:
            defaultMode: 420
            name: alertmanager-conf
          name: config-volume
        - emptyDir: {}
          name: storage-volume
---
apiVersion: v1
kind: Service
metadata:
  name: alertmanager
  namespace: monitoring
  labels:
    app: alertmanager
  annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/port:   '9093'
spec:
  selector:
    app: alertmanager
  type: NodePort
  ports:
  - port: 9093
    targetPort: 9093
    nodePort: 8081

::::::::::::::
prometheus-config-map.yml
::::::::::::::
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-server-conf
  labels:
    name: prometheus-server-conf
  namespace: monitoring
data:
  prometheus.yml: |-
    global:
      scrape_interval: 5s
      evaluation_interval: 5s

    alerting:
      alertmanagers:
      - kubernetes_sd_configs:
        - role: endpoints
        relabel_configs:
        - source_labels: [__meta_kubernetes_service_name]
          regex: alertmanager
          action: keep
        - source_labels: [__meta_kubernetes_namespace]
          regex: monitoring
          action: keep
        - source_labels: [__meta_kubernetes_pod_container_port_number]
          action: keep
          regex: 9093

    rule_files:
      - "/var/prometheus/rules/*_rules.yml"
      - "/var/prometheus/rules/*_alerts.yml"

    scrape_configs:
      - job_name: 'kubernetes-apiservers'

        kubernetes_sd_configs:
        - role: endpoints
        scheme: https

        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        relabel_configs:
        - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
          action: keep
          regex: default;kubernetes;https

      - job_name: 'kubernetes-nodes'

        scheme: https

        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        kubernetes_sd_configs:
        - role: node

        relabel_configs:
        - action: labelmap
          regex: __meta_kubernetes_node_label_(.+)
        - target_label: __address__
          replacement: kubernetes.default.svc:443
        - source_labels: [__meta_kubernetes_node_name]
          regex: (.+)
          target_label: __metrics_path__
          replacement: /api/v1/nodes/${1}/proxy/metrics


      - job_name: 'kubernetes-pods'

        kubernetes_sd_configs:
        - role: pod

        relabel_configs:
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
          action: keep
          regex: true
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
          action: replace
          target_label: __metrics_path__
          regex: (.+)
        - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
          action: replace
          regex: ([^:]+)(?::\d+)?;(\d+)
          replacement: $1:$2
          target_label: __address__
        - action: labelmap
          regex: __meta_kubernetes_pod_label_(.+)
        - source_labels: [__meta_kubernetes_namespace]
          action: replace
          target_label: kubernetes_namespace
        - source_labels: [__meta_kubernetes_pod_name]
          action: replace
          target_label: kubernetes_pod_name

      - job_name: 'kubernetes-cadvisor'

        scheme: https

        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        kubernetes_sd_configs:
        - role: node

        relabel_configs:
        - action: labelmap
          regex: __meta_kubernetes_node_label_(.+)
        - target_label: __address__
          replacement: kubernetes.default.svc:443
        - source_labels: [__meta_kubernetes_node_name]
          regex: (.+)
          target_label: __metrics_path__
          replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor

      - job_name: 'kubernetes-service-endpoints'

        kubernetes_sd_configs:
        - role: endpoints

        relabel_configs:
        - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
          action: keep
          regex: true
        - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scheme]
          action: replace
          target_label: __scheme__
          regex: (https?)
        - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
          action: replace
          target_label: __metrics_path__
          regex: (.+)
        - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
          action: replace
          target_label: __address__
          regex: ([^:]+)(?::\d+)?;(\d+)
          replacement: $1:$2
        - action: labelmap
          regex: __meta_kubernetes_service_label_(.+)
        - source_labels: [__meta_kubernetes_namespace]
          action: replace
          target_label: kubernetes_namespace
        - source_labels: [__meta_kubernetes_service_name]
          action: replace
          target_label: kubernetes_name
::::::::::::::
prometheus-deployment.yml
::::::::::::::
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: prometheus-deployment
  namespace: monitoring
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: prometheus-server
    spec:
      containers:
        - name: prometheus
          image: prom/prometheus:v2.2.1
          args:
            - "--config.file=/etc/prometheus/prometheus.yml"
            - "--storage.tsdb.path=/prometheus/"
            - "--web.enable-lifecycle"
          ports:
            - containerPort: 9090
          volumeMounts:
            - name: prometheus-config-volume
              mountPath: /etc/prometheus/
            - name: prometheus-rules-volume
              mountPath: /var/prometheus/rules
            - name: prometheus-storage-volume
              mountPath: /prometheus/
      volumes:
        - name: prometheus-config-volume
          configMap:
            defaultMode: 420
            name: prometheus-server-conf
        - name: prometheus-rules-volume
          configMap:
            name: prometheus-rules-conf
        - name: prometheus-storage-volume
          emptyDir: {}          
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus-service
  namespace: monitoring
  annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/port:   '9090'

spec:
  selector:
    app: prometheus-server
  type: NodePort
  ports:
    - port: 8080
      targetPort: 9090
      nodePort: 8080
::::::::::::::
prometheus-rules-config-map.yml
::::::::::::::
apiVersion: v1
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: prometheus-rules-conf
  namespace: monitoring
data:
  redis_rules.yml: |
    groups:
    - name: redis_rules
      rules:
      - record: redis:command_call_duration_seconds_count:rate2m
        expr: sum(irate(redis_command_call_duration_seconds_count[2m])) by (cmd, environment)
      - record: redis:total_requests:rate2m
        expr: rate(redis_commands_processed_total[2m])
  redis_alerts.yml: |
    groups:
    - name: redis_alerts
      rules:
      - alert: RedisServerDown
        expr: redis_up{app="media-redis"} == 0
        for: 10m
        labels:
          severity: critical
        annotations:
          summary: Redis Server {{ $labels.instance }} is down!
      - alert: RedisServerGone
        expr:  absent(redis_up{app="media-redis"})
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: No Redis servers are reporting!
::::::::::::::
redis.yml
::::::::::::::
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: media-redis-deployment
spec:
  replicas: 1
  template:
    metadata:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9121"
      labels:
        app: media-redis
    spec:
      volumes:
        - name: host-sys
          hostPath:
            path: /sys
      initContainers:
        - name: disable-thp
          image: redis:4.0-alpine
          volumeMounts:
            - name: host-sys
              mountPath: /host-sys
          command: ["sh", "-c", "echo never > /host-sys/kernel/mm/transparent_hugepage/enabled"]
      containers:
      - name: redis
        image: redis:4.0-alpine
        imagePullPolicy: IfNotPresent
        resources:
          requests:
            cpu: 250m
            memory: 500Mi
        ports:
        - containerPort: 6379
      - name: redis-exporter
        image: oliver006/redis_exporter:v0.21.1
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 9121
---
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9121"
  name: media-redis-svc
  labels:
    app: media-redis
spec:
  ports:
  - port: 6379
    name: redis
  - port: 9121
    name: metrics
  selector:
    app: media-redis

kubectl apply -f clusterRole.yml
kubectl apply -f namespaces.yml
kubectl apply -f prometheus-config-map.yml
kubectl apply -f prometheus-rules-config-map.yml
kubectl apply -f prometheus-deployment.yml
kubectl apply -f kube-state-metrics.yml
kubectl apply -f redis.yml
kubectl apply -f alertmanager-configmap.yml
kubectl apply -f alertmanager-depoloyment.yml

kubectl get pods -n monitoring
kubectl delete pods prometheus-deployment-8d4db8f98-q6ng2 -n monitoring

curl http://54.160.158.122:8080/alerts
```