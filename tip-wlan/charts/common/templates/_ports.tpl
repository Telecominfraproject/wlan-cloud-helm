{{/*
    This template will be used to iterate through the access point debug ports and generate
    access point debug ports mapping
  */}}


{{- define "container.dev.apdebugports" -}}
{{- $portPrefix := $.Values.global.nodePortPrefixExt | default $.Values.nodePortPrefixExt | int -}}
{{- $start := $.Values.accessPointDebugPortRange.start | int -}}
{{- $end := (add $.Values.accessPointDebugPortRange.start $.Values.accessPointDebugPortRange.length) | int -}}
{{- $portRangeStart := printf "%d%d" $portPrefix $start | atoi -}}
{{- $portRangeEnd := printf "%d%d" $portPrefix $end | atoi -}}
{{- $accessPointDebugPorts := untilStep $portRangeStart $portRangeEnd 1 -}}

  {{- range $index, $port := $accessPointDebugPorts }}
  - name: apdebugport-{{ $index }}
    containerPort: {{ $port }}
    protocol: TCP
  {{- end }}
{{- end -}}

{{- define "service.dev.apdebugports" -}}
{{- $portPrefix := $.Values.global.nodePortPrefixExt | default $.Values.nodePortPrefixExt | int -}}
{{- $start := $.Values.accessPointDebugPortRange.start | int -}}
{{- $end := (add $.Values.accessPointDebugPortRange.start $.Values.accessPointDebugPortRange.length) | int -}}
{{- $portRangeStart := printf "%d%d" $portPrefix $start | atoi -}}
{{- $portRangeEnd := printf "%d%d" $portPrefix $end | atoi -}}
{{- $accessPointDebugPorts := untilStep $portRangeStart $portRangeEnd 1 -}}

  {{- range $index, $port := $accessPointDebugPorts }}
  - port: {{ $port }}
    targetPort: {{ $port }}
    protocol: TCP
    name: apdebugport-{{ $index }}
    {{- if eq $.Values.service.type "NodePort" }}
    nodePort: {{ $port }}
    {{- end }}   
  {{- end }}
{{- end -}}