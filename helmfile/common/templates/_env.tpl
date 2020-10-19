{{- define "common.env" -}}
- name: {{ .Values.env.ssc_url }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.ssc.service }}:{{ .Values.env.ssc.port}}"
- name: {{ .Values.env.prov_url }}
  value: "{{ .Values.env.protocol }}://{{ .Release.Name }}-{{ .Values.env.prov.service }}:{{ .Values.env.prov.port}}"
{{- end -}}