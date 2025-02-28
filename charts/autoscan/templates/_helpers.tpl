{{- define "autoscan.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "autoscan.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "autoscan.labels" -}}
{{- if .Values.labels }}
{{ toYaml .Values.labels | nindent 4 }}
{{- end }}
{{- end }}

{{- define "autoscan.configYaml" -}}
minimum-age: {{ .Values.config.minimumAge }}
scan-delay: {{ .Values.config.scanDelay }}
port: {{ .Values.config.port }}

triggers:
  {{- if and .Values.config.triggers.lidarr .Values.config.triggers.lidarr.enabled }}
  lidarr:
    - name: lidarr
      priority: {{ .Values.config.triggers.lidarr.priority }}
  {{- end }}

  {{- if and .Values.config.triggers.radarr .Values.config.triggers.radarr.enabled }}
  radarr:
    - name: radarr
      priority: {{ .Values.config.triggers.radarr.priority }}
  {{- end }}

  {{- if and .Values.config.triggers.sonarr .Values.config.triggers.sonarr.enabled }}
  sonarr:
    - name: sonarr
      priority: {{ .Values.config.triggers.sonarr.priority }}
  {{- end }}

targets:
  plex:
    - url: {{ .Values.config.targets.plex.url | quote }}
      token: {{- if .Values.config.targets.plex.useTokenSecret -}}
        PLEX_TOKEN_PLACEHOLDER
      {{- else -}}
        {{ .Values.config.targets.plex.token | quote }}
      {{- end }}
{{- end }}
