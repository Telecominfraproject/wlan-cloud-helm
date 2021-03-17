{{/*
    This template provides various definitions used for integrating the JMX Prometheus exporter
  */}}

{{- define "jmxPrometheus.agentDir" -}}
/jmx-prometheus-exporter-dir
{{- end -}}

{{- define "jmxPrometheus.configPath" -}}
/app/jmx-prometheus-config.yml
{{- end -}}

{{- define "jmxPrometheus.portNumber" -}}
9404
{{- end -}}

{{- define "jmxPrometheus.initContainer" -}}
{{- if .Values.global.monitoring.enableJmxPrometheusMetrics -}}
- name: download-jmx-prometheus-exporter
  image: {{ .Values.global.downloadJmxExporterImage.registry }}/{{ .Values.global.downloadJmxExporterImage.repository }}:{{ .Values.global.downloadJmxExporterImage.tag }}
  command:
  - wget
  args:
  - -P
  - {{ include "jmxPrometheus.agentDir" . }}
  - {{ .Values.global.monitoring.jmxExporterAgentUrl }}
  volumeMounts:
{{ include "jmxPrometheus.tmpVolumeMount" . | indent 2 }}
{{- end -}}
{{- end -}}

{{- define "jmxPrometheus.port" -}}
{{- if .Values.global.monitoring.enableJmxPrometheusMetrics -}}
- name: jmx-prometheus
  containerPort: {{ include "jmxPrometheus.portNumber" . }}
  protocol: TCP
{{- end -}}
{{- end -}}

{{- define "jmxPrometheus.tmpVolume" -}}
{{- if .Values.global.monitoring.enableJmxPrometheusMetrics -}}
- name: jmx-prometheus-exporter-dir
  emptyDir: {}
{{- end -}}
{{- end -}}

{{- define "jmxPrometheus.tmpVolumeMount" -}}
{{- if .Values.global.monitoring.enableJmxPrometheusMetrics -}}
- name: jmx-prometheus-exporter-dir
  mountPath: {{ include "jmxPrometheus.agentDir" . }}
{{- end -}}
{{- end -}}

{{- define "jmxPrometheus.configVolume" -}}
{{- if .Values.global.monitoring.enableJmxPrometheusMetrics -}}
- name: tip-common-jmx-prometheus-config
  configMap:
      name: tip-common-jmx-prometheus-config
{{- end -}}
{{- end -}}

{{- define "jmxPrometheus.configVolumeMount" -}}
{{- if .Values.global.monitoring.enableJmxPrometheusMetrics -}}
- mountPath: {{ include "jmxPrometheus.configPath" . }}
  name: tip-common-jmx-prometheus-config
  subPath: jmx-prometheus-config.yml
{{- end -}}
{{- end -}}

{{- define "jmxPrometheus.jvmOpts" -}}
{{- if .Values.global.monitoring.enableJmxPrometheusMetrics -}}
-javaagent:{{ include "jmxPrometheus.agentDir" . }}/jmx_prometheus_javaagent-0.14.0.jar={{ include "jmxPrometheus.portNumber" . }}:{{ include "jmxPrometheus.configPath" . }}
{{- end -}}
{{- end -}}


{{- define "jmxPrometheus.podMonitor" -}}
{{- if and .Values.global.monitoring.enableJmxPrometheusMetrics .Values.global.monitoring.enablePrometheusPodMonitors -}}
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: {{ include "common.fullname" . }}
  namespace: {{ include "common.namespace" . }}
  labels:
    release: prometheus-operator
spec:
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
  podMetricsEndpoints:
  - port: jmx-prometheus
{{- end -}}
{{- end -}}