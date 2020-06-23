{{/*
    Resolve the Postgres service-name to apply to a chart. 
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

{{/*
  Resolve the Kafka service-name to apply to a chart. 
*/}}
{{- define "kafka.service" -}}
{{- printf "%s-%s" .Release.Name .Values.kafka.url | trunc 63 -}}
{{- end -}}

{{/*
  Resolve the integratedcloudcomponent service-name to apply to a chart. 
*/}}
{{- define "integratedcloudcomponent.service" -}}
  {{- printf "%s-%s:%.f" .Release.Name .Values.integratedcloudcomponent.url .Values.integratedcloudcomponent.port | trunc 63 -}}
{{- end -}}

{{/*
  Resolve the provisioning service-name to apply to a chart. 
*/}}
{{- define "prov.service" -}}
  {{- printf "%s-%s:%.f" .Release.Name .Values.prov.url .Values.prov.port | trunc 63 -}}
{{- end -}}

{{/*
  Resolve the ssc service-name to apply to a chart. 
*/}}
{{- define "ssc.service" -}}
  {{- printf "%s-%s:%.f" .Release.Name .Values.ssc.url .Values.ssc.port | trunc 63 -}}
{{- end -}}