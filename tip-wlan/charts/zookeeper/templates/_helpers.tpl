{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zookeeper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The name of the zookeeper headless service.
*/}}
{{- define "zookeeper.headless" -}}
{{- printf "%s-headless" (include "common.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The name of the zookeeper chroots job.
*/}}
{{- define "zookeeper.chroots" -}}
{{- printf "%s-chroots" (include "common.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
