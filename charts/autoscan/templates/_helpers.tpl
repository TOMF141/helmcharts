{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "autoscan.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "autoscan.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "autoscan.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "autoscan.labels" -}}
helm.sh/chart: {{ include "autoscan.chart" . }}
{{ include "autoscan.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "autoscan.selectorLabels" -}}
app.kubernetes.io/name: {{ include "autoscan.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "autoscan.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "autoscan.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "autoscan.deployment.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Render the config.yml content based on values.
*/}}
{{- define "autoscan.configYaml" -}}
# config.yml rendered by Helm chart {{ .Chart.Name }}-{{ .Chart.Version }}
minimum_age: {{ .Values.appConfig.minimumAge | quote }}
scan_delay: {{ .Values.appConfig.scanDelay | quote }}
port: {{ .Values.service.port }} # Use service port

triggers:
  lidarr:
    enabled: {{ .Values.appConfig.triggers.lidarr.enabled }}
    priority: {{ .Values.appConfig.triggers.lidarr.priority }}
  radarr:
    enabled: {{ .Values.appConfig.triggers.radarr.enabled }}
    priority: {{ .Values.appConfig.triggers.radarr.priority }}
  sonarr:
    enabled: {{ .Values.appConfig.triggers.sonarr.enabled }}
    priority: {{ .Values.appConfig.triggers.sonarr.priority }}

targets:
  plex:
    url: {{ .Values.appConfig.targets.plex.url | quote }}
    {{- if .Values.secretConfig.targets.plex.tokenSecretRef.name }}
    # Token will be injected by the deployment using the referenced secret
    token: PLEX_TOKEN_PLACEHOLDER_FROM_SECRETREF
    {{- else if .Values.secretConfig.targets.plex.token }}
    # Token is provided directly in values (less secure)
    token: {{ .Values.secretConfig.targets.plex.token | quote }}
    {{- else }}
    # No token provided
    token: ""
    {{- end }}
{{- end -}}
