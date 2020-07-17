{{/*
  Resolve the environment variables to apply to a chart. The default namespace suffix
  is the name of the chart. This can be overridden if necessary (eg. for subcharts)
  using the following value:

  - .Values.nsPrefix  : override namespace prefix
*/}}
{{- define "common.namespace" -}}
  {{- default .Values.global.nsPrefix -}}
{{- end -}}

{{- define "common.env" -}}
- name: {{ .Values.env.ssc_url }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.ssc.service }}:{{ .Values.env.ssc.port}}"
- name: {{ .Values.env.prov_url }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.prov.service }}:{{ .Values.env.prov.port}}"
{{- end -}}