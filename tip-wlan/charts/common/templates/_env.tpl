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
- name: {{ .Values.env.url.alarm }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.ssc.service }}:{{ .Values.env.ssc.port}}"
- name: {{ .Values.env.url.client }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.ssc.service }}:{{ .Values.env.ssc.port}}"
- name: {{ .Values.env.url.cloudEventDispatcher }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.ssc.service }}:{{ .Values.env.ssc.port}}"
- name: {{ .Values.env.url.customer }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.prov.service }}:{{ .Values.env.prov.port}}"
- name: {{ .Values.env.url.firmware }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.prov.service }}:{{ .Values.env.prov.port}}"
- name: {{ .Values.env.url.location }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.prov.service }}:{{ .Values.env.prov.port}}"
- name: {{ .Values.env.url.profile }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.ssc.service }}:{{ .Values.env.ssc.port}}"
- name: {{ .Values.env.url.serviceMetrics }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.prov.service }}:{{ .Values.env.prov.port}}"
- name: {{ .Values.env.url.equipment }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.prov.service }}:{{ .Values.env.prov.port}}"
- name: {{ .Values.env.url.manufacturer }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.prov.service }}:{{ .Values.env.prov.port}}"
- name: {{ .Values.env.url.portalUser }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.prov.service }}:{{ .Values.env.prov.port}}"
- name: {{ .Values.env.url.routing }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.ssc.service }}:{{ .Values.env.ssc.port}}"
- name: {{ .Values.env.url.status }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.ssc.service }}:{{ .Values.env.ssc.port}}"
- name: {{ .Values.env.url.systemEvent }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.ssc.service }}:{{ .Values.env.ssc.port}}"
{{- end -}}