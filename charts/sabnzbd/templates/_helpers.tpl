{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "appname.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "appname.fullname" -}}
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
{{- define "appname.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "appname.labels" -}}
helm.sh/chart: {{ include "appname.chart" . }}
{{ include "appname.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "appname.selectorLabels" -}}
app.kubernetes.io/name: {{ include "appname.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "appname.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "appname.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "appname.deployment.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Helper to render the sabnzbd.ini file content.
This uses values from .Values.appConfig and .Values.secretConfig.
It iterates through sections and key-value pairs.
Sensitive values (like api_key, nzb_key, server passwords/usernames)
should be defined in .Values.secretConfig.
*/}}
{{- define "sabnzbd.configfile" -}}
{{- $secretConfig := .Values.secretConfig }}
[misc]
{{- /* Merge sensitive keys from secretConfig into appConfig.misc for rendering */}}
{{- $miscConfig := mergeOverwrite .Values.appConfig.misc (dict "api_key" $secretConfig.apiKey "nzb_key" $secretConfig.nzbKey) }}
{{- range $key, $value := $miscConfig }}
{{ $key }} = {{ $value | quote }}
{{- end }}

{{- /* Iterate through server sections defined in appConfig */}}
{{- range $serverName, $serverValues := .Values.appConfig.servers }}
[{{ $serverName }}]
{{- /* Merge sensitive server keys from secretConfig into the current server's values */}}
{{- $secretServerValues := index $secretConfig.servers $serverName | default dict }}
{{- $mergedServerValues := mergeOverwrite $serverValues $secretServerValues }}
{{- range $key, $value := $mergedServerValues }}
{{ $key }} = {{ $value | quote }}
{{- end }}
{{- end }}

{{- /* Add other sections from appConfig if defined */}}
{{- range $sectionName, $sectionValues := omit .Values.appConfig "misc" "servers" }}
[{{ $sectionName }}]
{{- range $key, $value := $sectionValues }}
{{ $key }} = {{ $value | quote }}
{{- end }}
{{- end }}
{{- end -}}
