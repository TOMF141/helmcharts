{{- define "autoscan.name" -}}
{{ include "autoscan.fullname" . }}
{{- end -}}

{{- define "autoscan.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "autoscan.labels" -}}
{{- if .Values.labels }}
{{ toYaml .Values.labels | nindent 4 }}
{{- end }}
{{- end -}}
