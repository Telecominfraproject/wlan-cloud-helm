{{/*
    Resolve the Postgres service-name to apply to a chart. 
*/}}
{{- define "postgresql.service" -}}
  {{- printf "postgres-%s-%s" .Release.Namespace .Values.postgresql.url | trunc 63 -}}
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
{{- printf "kafka-%s-headless" .Release.Namespace | trunc 63 -}}
{{- end -}}

{{/*
  Resolve the Cassandra service-name to apply to a chart. 
*/}}
{{- define "cassandra.service" -}}
{{- printf "cassandra-%s-headless" .Release.Namespace | trunc 63 -}}
{{- end -}}

{{/*
  Resolve the MQTT service-name to apply to a chart. 
*/}}
{{- define "mqtt.service" -}}
{{- printf "%s-%s" .Release.Name .Values.mqtt.url | trunc 63 -}}
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

{{/*
  Resolve the Opensync-gw service-name to apply to a chart. 
*/}}
{{- define "opensyncgw.service" -}}
  {{- printf "%s-%s:%.f" .Release.Name .Values.opensyncgw.url .Values.opensyncgw.port | trunc 63 -}}
{{- end -}}


{{/*
  Resolve the pvc name that's would mounted to 2 charts - Portal and Opensync-gw 
*/}}
{{- define "portal.sharedPvc.name" -}}
{{- printf "%s-%s-%s-%.f" .Values.portal.sharedPvc.name .Release.Name .Values.portal.url .Values.portal.sharedPvc.ordinal | trunc 63 -}}
{{- end -}}

{{/*
  Resolve the filestore-directory name that's would mounted to 2 charts - Portal and Opensync-gw 
*/}}
{{- define "filestore.dir.name" -}}
  {{- printf "%s" .Values.filestore.internal | trunc 63 -}}
{{- end -}}