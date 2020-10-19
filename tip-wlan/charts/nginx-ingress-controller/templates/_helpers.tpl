{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the configmap.
*/}}
{{- define "nginx-ingress.configName" -}}
{{- default (include "common.name" .) .Values.controller.config.name -}}
{{- end -}}

{{/*
Expand leader election lock name.
*/}}
{{- define "nginx-ingress.leaderElectionName" -}}
{{- if .Values.controller.reportIngressStatus.leaderElectionLockName -}}
{{ .Values.controller.reportIngressStatus.leaderElectionLockName }}
{{- else -}}
{{- printf "%s-%s" (include "common.name" .) "leader-election" -}}
{{- end -}}
{{- end -}}

{{/*
Expand default TLS name.
*/}}
{{- define "nginx-ingress.defaultTLSName" -}}
{{- printf "%s-%s" (include "common.name" .) "default-server-secret" -}}
{{- end -}}

{{/*
Expand wildcard TLS name.
*/}}
{{- define "nginx-ingress.wildcardTLSName" -}}
{{- printf "%s-%s" (include "common.name" .) "wildcard-tls-secret" -}}
{{- end -}}

{{/*
Expand app name.
*/}}
{{- define "nginx-ingress.appName" -}}
{{- include "common.fullname" . -}}
{{- end -}}