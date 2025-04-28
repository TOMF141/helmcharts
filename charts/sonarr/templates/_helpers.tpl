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
Helper to render the config.xml file content for Sonarr.
This uses values from .Values.appConfig and .Values.secretConfig.
*/}}
{{- define "sonarr.configfile" -}}
<Config>
  <BindAddress>{{ .Values.appConfig.bindAddress | default "*" }}</BindAddress>
  <Port>{{ .Values.appConfig.port | default 8989 }}</Port>
  <SslPort>{{ .Values.appConfig.sslPort | default 9898 }}</SslPort>
  <EnableSsl>{{ .Values.appConfig.enableSsl | default "False" }}</EnableSsl>
  <LaunchBrowser>{{ .Values.appConfig.launchBrowser | default "True" }}</LaunchBrowser>
  <ApiKey>{{ .Values.secretConfig.apiKey | default (randAlphaNum 32) }}</ApiKey> {{/* Default to random if not provided */}}
  <AuthenticationMethod>{{ .Values.appConfig.authenticationMethod | default "External" }}</AuthenticationMethod>
  <AuthenticationRequired>{{ .Values.appConfig.authenticationRequired | default "DisabledForLocalAddresses" }}</AuthenticationRequired>
  <Branch>{{ .Values.appConfig.branch | default "main" }}</Branch>
  <LogLevel>{{ .Values.appConfig.logLevel | default "info" }}</LogLevel>
  <SslCertPath>{{ .Values.appConfig.sslCertPath | default "" }}</SslCertPath>
  <SslCertPassword>{{ .Values.secretConfig.sslCertPassword | default "" }}</SslCertPassword> {{/* Get from secretConfig */}}
  <UrlBase>{{ .Values.appConfig.urlBase | default "" }}</UrlBase>
  <InstanceName>{{ .Values.appConfig.instanceName | default "Sonarr" }}</InstanceName>
  <UpdateMechanism>{{ .Values.appConfig.updateMechanism | default "Docker" }}</UpdateMechanism>
  {{- if .Values.appConfig.postgres.enabled }}
  <PostgresUser>{{ .Values.appConfig.postgres.user }}</PostgresUser>
  <PostgresPassword>{{ .Values.secretConfig.postgresPassword }}</PostgresPassword> {{/* Get from secretConfig */}}
  <PostgresHost>{{ .Values.appConfig.postgres.host }}</PostgresHost>
  <PostgresPort>{{ .Values.appConfig.postgres.port | default 5432 }}</PostgresPort>
  <PostgresMainDb>{{ .Values.appConfig.postgres.mainDb }}</PostgresMainDb>
  <PostgresLogDb>{{ .Values.appConfig.postgres.logDb }}</PostgresLogDb>
  {{- end }}
</Config>
{{- end -}}
