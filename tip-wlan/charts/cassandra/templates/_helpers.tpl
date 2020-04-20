{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cassandra.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cassandra.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "cassandra.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
