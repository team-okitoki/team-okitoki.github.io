---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI OpenSearch, FluentBit, Fluentd를 활용한 OKE 로그 모니터링"
teaser: "OKE Cluster에 FluentBit과 Fluentd를 구성하고 OCI OpenSearch 서비스를 활용하여 모니터링 하는 방법에 대해서 살펴봅니다."
author: dankim
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, opensearch, opendashboard, elasticsearch, kibana, fluentbit, fluentd]
#
# Styling
#
header: no
#  image:
#    title: /assets/img/cloudnative-security/2022/weblogic_oke_0.png
#     thumb: /assets/img/cloudnative-security/2022/weblogic_oke_0.png
#     homepage: mediaplayer_js-home.jpg
#     caption: Photo by Corey Blaz
#     caption_url: https://blaz.photography/
# mediaplayer: true

---

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

### OCI Opensearch 클러스터 준비
먼저 OCI OpenSearch Cluster를 준비합니다. OCI OpenSearch 서비스에 대한 소개와 Cluster 생성 방법은 아래 포스팅을 참고합니다.

[OCI Opensearch 서비스 살펴보기](http://localhost:4000//cloudnative/oci-opensearch-overview/#5-oci-opensearch-%ED%81%B4%EB%9F%AC%EC%8A%A4%ED%84%B0-%EC%83%9D%EC%84%B1%ED%95%98%EA%B8%B0){:target="_blank" rel="noopener"}

### OKE Cluster 준비
OKE Cluster는 편의상 OCI OpenSearch Cluster가 생성된 동일한 VCN에 구성하도록 합니다. (다른 VCN에 구성하는 경우에는 VCN Peering 구성 필요)

OpenSearch에서 사용하는 VCN을 활용해야 하므로, OKE Cluster 생성 시 사용자 정의 생성 (Custom Create) 옵션을 선택하고, CNI 플러그인은 Flannel CNI 플러그인을 사용하여 구성하도록 하겠습니다. Flannel CNI 플러그인을 사용하여 사용자 정의로 OKE Cluster 생성하는 내용은 다음 포스트를 참고합니다. 

[Flannel CNI 플러그인으로 사용자 정의 OKE Cluster(Oracle Container Engine for Kubernetes) 클러스터 구성](https://team-okitoki.github.io/cloudnative/oke-cluster-with-flannel-cni/)

### 구성 아키텍처
여기서는 Log Collector(로그 수집)로 Fluent Bit, Log Aggregator (로그 집계 및 처리)로 Fluentd를 사용하도록 구성합니다. Log Collector 및 Aggregator를 모두 Fluentd로 구성할 수도 있고, 혹은 Fluent Bit로만 수집하여 바로 목적지에 전달할 수도 있습니다. 하지만 여기서는 다양한 소스로부터 데이터를 집계 및 처리하고 라우팅하는 등의 작업을 중앙에서 처리해야 한다는 가정하에, Fluentd보다 훨씬 경량의 Fluent Bit로 Collector 역할만 따로 담당하도록 분리하여 구성하고, 복잡한 집계 처리 및 라우팅은 Fluentd에 맡기는 형태로 구성해 보도록 합니다. 

> 참고) Fluent Bit은 Fluentd 프로젝트 에코시스템의 서브 컴포넌트이며, Fluentd의 경량화된 Forwarder 역할을 합니다. 초기에 임베디드 리눅스 환경에서 사용하기 위해 개발되어서 매우 가볍고 속도가 빠른 특징을 가지고 있습니다.

![](/assets/img/cloudnative-security/2022/opensearch-fluentbit-fluentd-2.png)

OKE Cluster에 Fluent Bit와 Fluentd 구성 아키텍처입니다. Fluent Bit는 모든 노드의 로그를 수집하기 위해 DaemonSet으로 구성이 되며, 수집된 로그는 Fluentd로 전달되는 구성입니다.

![](/assets/img/cloudnative-security/2022/opensearch-fluentbit-fluentd-1.png)

### Fluent Bit 설치
Fluent Bit을 OKE Cluster에 구성할 수 있게 Helm Chart가 제공됩니다. Helm은 쿠버네티스 패키지 매니저로 설치는 다음 링크를 참고합니다.

[Installing Helm](https://helm.sh/docs/intro/install/)

우선 Fluent Bit Helm 저장소를 추가합니다.

```
$ helm repo add fluent https://fluent.github.io/helm-charts
"fluent" has been added to your repositories
```

Fluentbit Helm Chart에서 사용할 values.yaml을 준비합니다. yaml 파일은 아래 Github 저장소에서 다운받을 수 있습니다.

[Fluentbit_values.yaml](https://github.com/PA2702/OpenSearch-Log-Ingestion/blob/Fluentd%2BFluentbit/Fluentbit_values.yaml)

***Fluentbit_values.yaml***
```
# Default values for fluent-bit.

# kind -- DaemonSet or Deployment
kind: DaemonSet

# replicaCount -- Only applicable if kind=Deployment
replicaCount: 1

image:
  repository: cr.fluentbit.io/fluent/fluent-bit
  # Overrides the image tag whose default is {{ .Chart.AppVersion }}
  tag: ""
  pullPolicy: Always

testFramework:
  image:
    repository: busybox
    pullPolicy: Always
    tag: latest

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  create: true
  annotations: {}
  name:

rbac:
  create: true
  nodeAccess: false

podSecurityPolicy:
  create: false
  annotations: {}

openShift:
  # Sets Openshift support
  enabled: false
  # Creates SCC for Fluent-bit when Openshift support is enabled
  securityContextConstraints:
    create: true
    annotations: {}

podSecurityContext: {}
#   fsGroup: 2000

hostNetwork: false
dnsPolicy: ClusterFirst

dnsConfig: {}
#   nameservers:
#     - 1.2.3.4
#   searches:
#     - ns1.svc.cluster-domain.example
#     - my.dns.search.suffix
#   options:
#     - name: ndots
#       value: "2"
#     - name: edns0

hostAliases: []
#   - ip: "1.2.3.4"
#     hostnames:
#     - "foo.local"
#     - "bar.local"

securityContext: {}
#   capabilities:
#     drop:
#     - ALL
#   readOnlyRootFilesystem: true
#   runAsNonRoot: true
#   runAsUser: 1000

service:
  type: ClusterIP
  port: 2020
  labels: {}
  # nodePort: 30020
  # clusterIP: 172.16.10.1
  annotations: {}
#   prometheus.io/path: "/api/v1/metrics/prometheus"
#   prometheus.io/port: "2020"
#   prometheus.io/scrape: "true"

serviceMonitor:
  enabled: false
#   namespace: monitoring
#   interval: 10s
#   scrapeTimeout: 10s
#   jobLabel: fluentbit
#   selector:
#    prometheus: my-prometheus
#  ## metric relabel configs to apply to samples before ingestion.
#  ##
#  metricRelabelings:
#    - sourceLabels: [__meta_kubernetes_service_label_cluster]
#      targetLabel: cluster
#      regex: (.*)
#      replacement: ${1}
#      action: replace
#  ## relabel configs to apply to samples after ingestion.
#  ##
#  relabelings:
#    - sourceLabels: [__meta_kubernetes_pod_node_name]
#      separator: ;
#      regex: ^(.*)$
#      targetLabel: nodename
#      replacement: $1
#      action: replace

prometheusRule:
  enabled: false
#   namespace: ""
#   additionalLabels: {}
#   rules:
#   - alert: NoOutputBytesProcessed
#     expr: rate(fluentbit_output_proc_bytes_total[5m]) == 0
#     annotations:
#       message: |
#         Fluent Bit instance {{ $labels.instance }}'s output plugin {{ $labels.name }} has not processed any
#         bytes for at least 15 minutes.
#       summary: No Output Bytes Processed
#     for: 15m
#     labels:
#       severity: critical

dashboards:
  enabled: false
  labelKey: grafana_dashboard
  annotations: {}
  namespace: ""

lifecycle: {}
  # preStop:
  #   exec:
  #     command: ["/bin/sh", "-c", "sleep 20"]

livenessProbe:
  httpGet:
    path: /
    port: http

readinessProbe:
  httpGet:
    path: /api/v1/health
    port: http

resources: {}
#   limits:
#     cpu: 100m
#     memory: 128Mi
#   requests:
#     cpu: 100m
#     memory: 128Mi

## only available if kind is Deployment
ingress:
  enabled: false
  className: ""
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  hosts: []
  # - host: fluent-bit.example.tld
  extraHosts: []
  # - host: fluent-bit-extra.example.tld
      ## specify extraPort number
  #   port: 5170
  tls: []
  #  - secretName: fluent-bit-example-tld
  #    hosts:
  #      - fluent-bit.example.tld

## only available if kind is Deployment
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 3
  targetCPUUtilizationPercentage: 75
#  targetMemoryUtilizationPercentage: 75
   ## see https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#autoscaling-on-multiple-metrics-and-custom-metrics
  customRules: []
#     - type: Pods
#       pods:
#         metric:
#           name: packets-per-second
#         target:
#           type: AverageValue
#           averageValue: 1k
    ## see https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#support-for-configurable-scaling-behavior
  behavior: {}
#      scaleDown:
#        policies:
#          - type: Pods
#            value: 4
#            periodSeconds: 60
#          - type: Percent
#            value: 10
#            periodSeconds: 60

## only available if kind is Deployment
podDisruptionBudget:
  enabled: false
  annotations: {}
  maxUnavailable: "30%"

nodeSelector: {}

tolerations: []

affinity: {}

labels: {}

annotations: {}

podAnnotations: {}

podLabels: {}

priorityClassName: ""

env: []
#  - name: FOO
#    value: "bar"

# The envWithTpl array below has the same usage as "env", but is using the tpl function to support templatable string.
# This can be useful when you want to pass dynamic values to the Chart using the helm argument "--set <variable>=<value>"
# https://helm.sh/docs/howto/charts_tips_and_tricks/#using-the-tpl-function
envWithTpl: []
#  - name: FOO_2
#    value: "{{ .Values.foo2 }}"
#
# foo2: bar2

envFrom: []

extraContainers: []
#   - name: do-something
#     image: busybox
#     command: ['do', 'something']

flush: 1

metricsPort: 2020

extraPorts: []
#   - port: 5170
#     containerPort: 5170
#     protocol: TCP
#     name: tcp
#     nodePort: 30517

extraVolumes: []

extraVolumeMounts: []

updateStrategy: {}
#   type: RollingUpdate
#   rollingUpdate:
#     maxUnavailable: 1

# Make use of a pre-defined configmap instead of the one templated here
existingConfigMap: ""

networkPolicy:
  enabled: false
#   ingress:
#     from: []

luaScripts: {}

## https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/configuration-file
config:
  service: |
    [SERVICE]
        Daemon Off
        Flush {{ .Values.flush }}
        Log_Level {{ .Values.logLevel }}
        Parsers_File parsers.conf
        Parsers_File custom_parsers.conf
        HTTP_Server On
        HTTP_Listen 0.0.0.0
        HTTP_Port {{ .Values.metricsPort }}
        Health_Check On
  ## https://docs.fluentbit.io/manual/pipeline/inputs
  inputs: |
    [INPUT]
        Name tail
        Path /var/log/containers/*.log
        multiline.parser docker, cri
        Tag kube.*
        Mem_Buf_Limit 5MB
        Skip_Long_Lines On
    [INPUT]
        Name systemd
        Tag host.*
        Systemd_Filter _SYSTEMD_UNIT=kubelet.service
        Read_From_Tail On
  ## https://docs.fluentbit.io/manual/pipeline/filters
  filters: |
    [FILTER]
        Name kubernetes
        Match kube.*
        Merge_Log On
        Keep_Log Off
        K8S-Logging.Parser On
        K8S-Logging.Exclude On
  ## https://docs.fluentbit.io/manual/pipeline/outputs
  outputs: |
    [OUTPUT]
        Name          forward
        Match         *
        Host          fluentd
        Port          24224
        Retry_Limit False
        tls           off
        tls.verify    on
        tls.debug     1
  ## https://docs.fluentbit.io/manual/pipeline/parsers
  customParsers: |
    [PARSER]
        Name docker_no_time
        Format json
        Time_Keep Off
        Time_Key time
        Time_Format %Y-%m-%dT%H:%M:%S.%L
  # This allows adding more files with arbitary filenames to /fluent-bit/etc by providing key/value pairs.
  # The key becomes the filename, the value becomes the file content.
  extraFiles: {}
#     example.conf: |
#       [OUTPUT]
#           Name example
#           Match foo.*
#           Host bar

# The config volume is mounted by default, either to the existingConfigMap value, or the default of "fluent-bit.fullname"
volumeMounts:
  - name: config
    mountPath: /fluent-bit/etc/fluent-bit.conf
    subPath: fluent-bit.conf
  - name: config
    mountPath: /fluent-bit/etc/custom_parsers.conf
    subPath: custom_parsers.conf

daemonSetVolumes:
  - name: varlog
    hostPath:
      path: /var/log
  - name: varlibdockercontainers
    hostPath:
      path: /var/lib/docker/containers
  - name: etcmachineid
    hostPath:
      path: /etc/machine-id
      type: File

daemonSetVolumeMounts:
  - name: varlog
    mountPath: /var/log
  - name: varlibdockercontainers
    mountPath: /var/lib/docker/containers
    readOnly: true
  - name: etcmachineid
    mountPath: /etc/machine-id
    readOnly: true

args: []

command: []

# This supports either a structured array or a templatable string
initContainers: []

# Array mode
# initContainers:
#   - name: do-something
#     image: bitnami/kubectl:1.22
#     command: ['kubectl', 'version']

# String mode
# initContainers: |-
#   - name: do-something
#     image: bitnami/kubectl:{{ .Capabilities.KubeVersion.Major }}.{{ .Capabilities.KubeVersion.Minor }}
#     command: ['kubectl', 'version']

logLevel: info
```

Fluent Bit Helm Chart를 활용하여 OKE 배포합니다.
```
$ helm upgrade --install fluent-bit fluent/fluent-bit -f Fluentbit_values.yaml
```

배포된 Fluent Bit을 확인합니다.
```
$ kubectl get all
NAME                   READY   STATUS    RESTARTS   AGE
pod/fluent-bit-cd7s4   1/1     Running   0          3m5s
pod/fluent-bit-jp4dg   1/1     Running   0          3m6s
pod/fluent-bit-xt4fz   1/1     Running   0          3m5s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)             AGE
service/fluent-bit   ClusterIP   10.96.20.7   <none>        2020/TCP            3m6s
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP,12250/TCP   134m

NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/fluent-bit   3         3         3       3            3           <none>          3m6s
```

### Fluentd 설치
Fluent Bit와 마찬가지로 Fluentd도 Helm Chart가 제공됩니다. Helm 레파지토리는 앞서 추가한 레파지토리를 그대로 사용합니다.

Fluentbit Helm Chart에서 사용할 values.yaml을 준비합니다. yaml 파일은 아래 Github 저장소에서 다운받을 수 있습니다.

[Fluentd_values.yaml](https://github.com/PA2702/OpenSearch-Log-Ingestion/blob/Fluentd%2BFluentbit/Fluentd_values.yaml)

***Fluentd_values.yaml***
```
nameOverride: ""
fullnameOverride: ""

# DaemonSet, Deployment or StatefulSet
kind: "Deployment"

# # Only applicable for Deployment or StatefulSet
# replicaCount: 1

image:
  repository: "fluent/fluentd-kubernetes-daemonset"
  pullPolicy: "IfNotPresent"
  tag: ""

## Optional array of imagePullSecrets containing private registry credentials
## Ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
imagePullSecrets: []

serviceAccount:
  create: true
  annotations: {}
  name: null

rbac:
  create: true

# Configure podsecuritypolicy
# Ref: https://kubernetes.io/docs/concepts/policy/pod-security-policy/
podSecurityPolicy:
  enabled: true
  annotations: {}

## Security Context policies for controller pods
## See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for
## notes on enabling and using sysctls
##
podSecurityContext: {}
  # seLinuxOptions:
  #   type: "spc_t"

securityContext: {}
  # capabilities:
  #   drop:
  #   - ALL
  # readOnlyRootFilesystem: true
  # runAsNonRoot: true
  # runAsUser: 1000

# Configure the livecycle
# Ref: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/
lifecycle: {}
  # preStop:
  #   exec:
  #     command: ["/bin/sh", "-c", "sleep 20"]

# Configure the livenessProbe
# Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
livenessProbe:
  httpGet:
    path: /metrics
    port: metrics
  initialDelaySeconds: 3
  periodSeconds: 10
  timeoutSeconds: 1
  successThreshold: 1
  failureThreshold: 3
  # initialDelaySeconds: 0
  # periodSeconds: 10
  # timeoutSeconds: 1
  # successThreshold: 1
  # failureThreshold: 3

# Configure the readinessProbe
# Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
readinessProbe:
  httpGet:
    path: /metrics
    port: metrics
  initialDelaySeconds: 3
  periodSeconds: 10
  timeoutSeconds: 1
  successThreshold: 1
  failureThreshold: 3
  # initialDelaySeconds: 0
  # periodSeconds: 10
  # timeoutSeconds: 1
  # successThreshold: 1
  # failureThreshold: 3

resources: {}
  # requests:
  #   cpu: 10m
  #   memory: 128Mi
  # limits:
  #   memory: 128Mi

## only available if kind is Deployment
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80
  # targetMemoryUtilizationPercentage: 80
  ## see https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#autoscaling-on-multiple-metrics-and-custom-metrics
  customRules: []
    # - type: Pods
    #   pods:
    #     metric:
    #       name: packets-per-second
    #     target:
    #       type: AverageValue
    #       averageValue: 1k
  ## see https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#support-for-configurable-scaling-behavior
  # behavior:
  #   scaleDown:
  #     policies:
  #       - type: Pods
  #         value: 4
  #         periodSeconds: 60
  #       - type: Percent
  #         value: 10
  #         periodSeconds: 60

# priorityClassName: "system-node-critical"

nodeSelector: {}

## Node tolerations for server scheduling to nodes with taints
## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
##
tolerations: []
# - key: null
#   operator: Exists
#   effect: "NoSchedule"

## Affinity and anti-affinity
## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
##
affinity: {}

## Annotations to be added to fluentd DaemonSet/Deployment
##
annotations: {}

## Labels to be added to fluentd DaemonSet/Deployment
##
labels: {}

## Annotations to be added to fluentd pods
##
podAnnotations: {}

## Labels to be added to fluentd pods
##
podLabels: {}

## How long (in seconds) a pods needs to be stable before progressing the deployment
##
minReadySeconds:

## How long (in seconds) a pod may take to exit (useful with lifecycle hooks to ensure lb deregistration is done)
##
terminationGracePeriodSeconds:

## Deployment strategy / DaemonSet updateStrategy
##
updateStrategy: {}
#   type: RollingUpdate
#   rollingUpdate:
#     maxUnavailable: 1

## Additional environment variables to set for fluentd pods
env:
- name: "FLUENTD_CONF"
  value: "../../../etc/fluent/fluent.conf"
  # - name: FLUENT_ELASTICSEARCH_HOST
  #   value: "elasticsearch-master"
  # - name: FLUENT_ELASTICSEARCH_PORT
  #   value: "9200"

envFrom: []

volumes:
- name: varlog
  hostPath:
    path: /var/log
- name: varlibdockercontainers
  hostPath:
    path: /var/lib/docker/containers
- name: etcfluentd-main
  configMap:
    name: fluentd-main
    defaultMode: 0777
- name: etcfluentd-config
  configMap:
    name: fluentd-config
    defaultMode: 0777

volumeMounts:
- name: varlog
  mountPath: /var/log
- name: varlibdockercontainers
  mountPath: /var/lib/docker/containers
  readOnly: true
- name: etcfluentd-main
  mountPath: /etc/fluent
- name: etcfluentd-config
  mountPath: /etc/fluent/config.d/

## Only available if kind is StatefulSet
## Fluentd persistence
##
persistence:
  enabled: false
  storageClass: ""
  accessMode: ReadWriteOnce
  size: 10Gi

## Fluentd service
##
service:
  type: "ClusterIP"
  annotations: {}
  # loadBalancerIP:
  # externalTrafficPolicy: Local
  ports:
    - name: "forwarder"
      protocol: TCP
      containerPort: 24224

## Prometheus Monitoring
##
metrics:
  serviceMonitor:
    enabled: false
    additionalLabels:
      release: prometheus-operator
    namespace: ""
    namespaceSelector: {}
    ## metric relabel configs to apply to samples before ingestion.
    ##
    metricRelabelings: []
    # - sourceLabels: [__name__]
    #   separator: ;
    #   regex: ^fluentd_output_status_buffer_(oldest|newest)_.+
    #   replacement: $1
    #   action: drop
    ## relabel configs to apply to samples after ingestion.
    ##
    relabelings: []
    # - sourceLabels: [__meta_kubernetes_pod_node_name]
    #   separator: ;
    #   regex: ^(.*)$
    #   targetLabel: nodename
    #   replacement: $1
    #   action: replace
    ## Additional serviceMonitor config
    ##
    # jobLabel: fluentd
    # scrapeInterval: 30s
    # scrapeTimeout: 5s
    # honorLabels: true

  prometheusRule:
    enabled: false
    additionalLabels: {}
    namespace: ""
    rules: []
    # - alert: FluentdDown
    #   expr: up{job="fluentd"} == 0
    #   for: 5m
    #   labels:
    #     context: fluentd
    #     severity: warning
    #   annotations:
    #     summary: "Fluentd Down"
    #     description: "{{ $labels.pod }} on {{ $labels.nodename }} is down"
    # - alert: FluentdScrapeMissing
    #   expr: absent(up{job="fluentd"} == 1)
    #   for: 15m
    #   labels:
    #     context: fluentd
    #     severity: warning
    #   annotations:
    #     summary: "Fluentd Scrape Missing"
    #     description: "Fluentd instance has disappeared from Prometheus target discovery"

## Grafana Monitoring Dashboard
##
dashboards:
  enabled: "true"
  namespace: ""
  labels:
    grafana_dashboard: '"1"'

## Fluentd list of plugins to install
##
plugins: 
# - fluent-plugin-out-http
- fluent-plugin-opensearch

## Add fluentd config files from K8s configMaps
##
configMapConfigs:
  - fluentd-prometheus-conf
# - fluentd-systemd-conf

## Fluentd configurations:
##
fileConfigs:
  01_sources.conf: |-
    <source>
      @type forward
      @label @KUBERNETES
      port 24224
      bind 0.0.0.0
    </source>

  02_filters.conf: |-
    <label @KUBERNETES>
      <match kubernetes.var.log.containers.fluentd**>
        @type relabel
        @label @FLUENT_LOG
      </match>

      # <match kubernetes.var.log.containers.**_kube-system_**>
      #   @type null
      #   @id ignore_kube_system_logs
      # </match>

      <filter kubernetes.**>
        @type kubernetes_metadata
        @id filter_kube_metadata
        skip_labels false
        skip_container_metadata false
        skip_namespace_metadata true
        skip_master_url true
      </filter>

      <match **>
        @type relabel
        @label @DISPATCH
      </match>
    </label>

  03_dispatch.conf: |-
    <label @DISPATCH>
      <filter **>
        @type prometheus
        <metric>
          name fluentd_input_status_num_records_total
          type counter
          desc The total number of incoming records
          <labels>
            tag ${tag}
            hostname ${hostname}
          </labels>
        </metric>
      </filter>

      <match **>
        @type relabel
        @label @OUTPUT
      </match>
    </label>

  04_outputs.conf: |-
    <label @OUTPUT>
      <match **>
        @type opensearch
        @id opensearch
        @log_level info
        include_tag_key true
        type_name _doc
        host "<OPENSEARCH URL>"
        port 9200
        scheme https
        ssl_verify false
        ssl_version TLSv1_2
        suppress_type_name true
      </match>
    </label>
```

Fluentd_values.yaml 파일내의 `<OPENSEARCH URL>`을 OCI OpenSearch URL로 변경합니다. OpenSearch URL은 생성한 OCI OpenSearch Cluster 상세 페이지에서 확인할 수 있습니다.

![](/assets/img/cloudnative-security/2022/opensearch-fluentbit-fluentd-3.png)

변경 예시
```
04_outputs.conf: |-
    <label @OUTPUT>
      <match **>
        @type opensearch
        @id opensearch
        @log_level info
        include_tag_key true
        type_name _doc
        host "amaaaaaavsea7yia7qowt3....................opensearch.ap-seoul-1.oci.oraclecloud.com"
        port 9200
        scheme https
        ssl_verify false
        ssl_version TLSv1_2
        suppress_type_name true
      </match>
    </label>
```

이제 Fluentd Helm Chart를 활용하여 OKE 배포합니다.
```
$ helm upgrade --install fluentd fluent/fluentd -f Fluentd_values.yaml
```

배포된 Fluentd를 확인합니다.
```
$ kubectl get all
NAME                                  READY   STATUS    RESTARTS   AGE
pod/fluent-bit-cd7s4                  1/1     Running   0          32m
pod/fluent-bit-jp4dg                  1/1     Running   0          32m
pod/fluent-bit-xt4fz                  1/1     Running   0          32m
pod/fluentd-fluentd-6cb89f56c8-sbbmj  1/1     Running   0          9m22s

NAME                     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)               AGE
service/fluent-bit       ClusterIP   10.96.20.7     <none>        2020/TCP              32m
service/fluent-fluentd   ClusterIP   10.96.105.72   <none>        24231/TCP,24224/TCP   13m
service/kubernetes       ClusterIP   10.96.0.1      <none>        443/TCP,12250/TCP     163m

NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/fluent-bit   3         3         3       3            3           <none>          32m

NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/fluent-fluentd   1/1     1            1           13m

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/fluent-fluentd-6cb89f56c8   1         1         1       9m22s
replicaset.apps/fluent-fluentd-8668855d46   0         0         0       13m
```

### 샘플 애플리케이션 배포
간단한 애플리케이션을 배포하여 모니터링 해보도록 합니다. 

먼저 Ingress Controller를 생성합니다.
```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.3/deploy/static/provider/cloud/deploy.yaml
```

간단한 애플리케이션 (docker-hello-world)을 배포하기 위해 다음 Manifest를 작성합니다.

***hello-world-ingress.yaml***
```
hello-world-ingress.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: docker-hello-world
  labels:
    oke-app: docker-hello-world
spec:
  selector:
    matchLabels:
      oke-app: docker-hello-world
  replicas: 3
  template:
    metadata:
      labels:
        oke-app: docker-hello-world
    spec:
      containers:
      - name: docker-hello-world
        image: scottsbaldwin/docker-hello-world:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: docker-hello-world-svc
spec:
  selector:
    oke-app: docker-hello-world
  ports:
    - port: 8088
      targetPort: 80
  type: ClusterIP
```

Deployment와 서비스를 생성합니다.

```
$ kubectl create -f hello-world-ingress.yaml
```

Ingress Manifest 파일을 작성합니다

***ingress.yaml***
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-world-ing
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: docker-hello-world-svc
              port:
                number: 8088
```

Ingress를 생성합니다.
```
$ kubectl create -f ingress.yaml
````

External IP를 확인합니다.
```
$ kubectl get svc -n ingress-nginx
NAME                                 TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.96.44.164   146.xx.xx.xx   80:31713/TCP,443:32598/TCP   11m
ingress-nginx-controller-admission   ClusterIP      10.96.44.45    <none>         443/TCP                      11m
```

curl을 사용해서 호출 테스트를 합니다.
```
$ curl -I http://146.xx.xx.xx
HTTP/1.1 200 OK
Date: Sat, 22 Oct 2022 07:56:06 GMT
Content-Type: text/html
Content-Length: 71
Connection: keep-alive
Last-Modified: Sat, 22 Oct 2022 07:47:02 GMT
ETag: "63539ff6-47"
Accept-Ranges: bytes
```

### OpenSearch 대시보드에서 로그 모니터링
아래 포스트 참고하여 OpenSearch 대시보드를 오픈합니다. 

[OCI Opensearch 서비스 살펴보기](http://localhost:4000//cloudnative/oci-opensearch-overview/#5-oci-opensearch-%ED%81%B4%EB%9F%AC%EC%8A%A4%ED%84%B0-%EC%83%9D%EC%84%B1%ED%95%98%EA%B8%B0){:target="_blank" rel="noopener"}

메뉴에서 **Stack Management > Index Patterns**를 선택한 후 **Create index pattern** 을 클릭합니다.

![](/assets/img/cloudnative-security/2022/opensearch-fluentbit-fluentd-4.png)

**Index pattern name**에 **fluentd**로 입력한 후 **Next Step**을 클릭합니다.

![](/assets/img/cloudnative-security/2022/opensearch-fluentbit-fluentd-5.png)

**Time filed**를 선택한 후 **Create index pattern**을 클릭합니다.

![](/assets/img/cloudnative-security/2022/opensearch-fluentbit-fluentd-6.png)

매뉴에서 **Discover**를 선택합니다. Index pattern을 **fluentd**로 변경합니다.

![](/assets/img/cloudnative-security/2022/opensearch-fluentbit-fluentd-7.png)

다음과 같이 앞서 배포한 docker-hello-world 서비스에 대한 로그를 확인할 수 있습니다.

![](/assets/img/cloudnative-security/2022/opensearch-fluentbit-fluentd-8.png)
![](/assets/img/cloudnative-security/2022/opensearch-fluentbit-fluentd-9.png)

### 참고
* https://blogs.oracle.com/cloud-infrastructure/post/using-oci-opensearch-ingest-logs-from-kubernetes-using-fluentbit-and-fluentd
* https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengsettingupingresscontroller.htm