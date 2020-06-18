{{/*
    Resolve the service-name to apply to a chart. 
  */}}
  {{- define "postgresql.service" -}}
    {{- printf "%s-%s" .Release.Name .Values.postgresql.url | trunc 63 -}}
  {{- end -}}

{{/*
Form the Zookeeper Service. If zookeeper is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "zookeeper.service" }}
{{- if .Values.zookeeper.enabled -}}
{{- printf "%s" (include "kafka.zookeeper.fullname" .) }}
{{- else -}}
{{- $zookeeperService := printf "%s-%s" .Release.Name .Values.zookeeper.url }}
{{- default $zookeeperService }}
{{- end -}}
{{- end -}}  
