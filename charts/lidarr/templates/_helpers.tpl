{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "lidarr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "lidarr.fullname" -}}
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
{{- define "lidarr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "lidarr.labels" -}}
helm.sh/chart: {{ include "lidarr.chart" . }}
{{ include "lidarr.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "lidarr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lidarr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "lidarr.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "lidarr.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "lidarr.deployment.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Helper to render the config.xml file content for Lidarr.
*/}}
{{- define "lidarr.configXml" -}}
<Config>
  <BindAddress>{{ .Values.secretConfig.bindAddress | default "*" }}</BindAddress>
  <Port>{{ .Values.secretConfig.port | default 8686 }}</Port>
  <SslPort>{{ .Values.secretConfig.sslPort | default 9898 }}</SslPort>
  <EnableSsl>{{ .Values.secretConfig.enableSsl | default "False" }}</EnableSsl>
  <LaunchBrowser>{{ .Values.secretConfig.launchBrowser | default "True" }}</LaunchBrowser>
  {{- /* Handle apiKey coming from values or secret */}}
  {{- $apiKey := default .Values.secretConfig.apiKey (include "lidarr.secretValue" (dict "secretRef" .Values.secretConfig.apiKeySecretRef "context" $)) -}}
  {{- if not $apiKey -}}
  {{- fail "API key is required. Please provide it either in values.yaml (secretConfig.apiKey) or as a secret reference (secretConfig.apiKeySecretRef)" -}}
  {{- end -}}
  <ApiKey>{{ $apiKey }}</ApiKey>
  <AuthenticationMethod>{{ .Values.secretConfig.authenticationMethod | default "External" }}</AuthenticationMethod>
  <AuthenticationRequired>{{ .Values.secretConfig.authenticationRequired | default "DisabledForLocalAddresses" }}</AuthenticationRequired>
  <Branch>{{ .Values.secretConfig.branch | default "main" }}</Branch>
  <LogLevel>{{ .Values.secretConfig.logLevel | default "info" }}</LogLevel>
  <SslCertPath>{{ .Values.secretConfig.sslCertPath | default "" }}</SslCertPath>
  {{- /* Handle sslCertPassword potentially coming from a secret */}}
  <SslCertPassword>{{ default .Values.secretConfig.sslCertPassword (include "lidarr.secretValue" (dict "secretRef" .Values.secretConfig.sslCertPasswordSecretRef "context" $)) | default "" }}</SslCertPassword>
  <UrlBase>{{ .Values.secretConfig.urlBase | default "" }}</UrlBase>
  <InstanceName>{{ .Values.secretConfig.instanceName | default "Lidarr" }}</InstanceName>
  <UpdateMechanism>{{ .Values.secretConfig.updateMechanism | default "Docker" }}</UpdateMechanism>
</Config>
{{- end -}}

{{/*
Get a value from a Kubernetes secret
Usage:
{{ include "lidarr.secretValue" (dict "secretRef" .Values.secretConfig.apiKeySecretRef "context" $) }}
*/}}
{{- define "lidarr.secretValue" -}}
{{- $secretRef := .secretRef -}}
{{- $context := .context -}}
{{- if and $secretRef $secretRef.name $secretRef.key -}}
  {{- $secretObj := (lookup "v1" "Secret" $context.Release.Namespace $secretRef.name) -}}
  {{- if $secretObj -}}
    {{- if (hasKey $secretObj.data $secretRef.key) -}}
      {{- index $secretObj.data $secretRef.key | b64dec -}}
    {{- else -}}
      {{- /* Return empty string if key doesn't exist */ -}}
    {{- end -}}
  {{- else -}}
    {{- /* Return empty string if secret doesn't exist */ -}}
  {{- end -}}
{{- else -}}
  {{- /* Return empty string if secretRef is incomplete */ -}}
{{- end -}}
{{- end -}}

{{/*
Alias for configXml to maintain compatibility with secret.yaml
*/}}
{{- define "lidarr.configfile" -}}
{{- include "lidarr.configXml" . -}}
{{- end -}}
