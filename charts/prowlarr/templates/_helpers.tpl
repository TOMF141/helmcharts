{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prowlarr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prowlarr.fullname" -}}
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
{{- define "prowlarr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels - Generates the full label block
*/}}
{{- define "prowlarr.labels" -}}
helm.sh/chart: {{ include "prowlarr.chart" . }}
{{ include "prowlarr.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "prowlarr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "prowlarr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "prowlarr.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "prowlarr.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "prowlarr.deployment.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Helper to render the Prowlarr config.xml file content.
Reads values from .Values.secretConfig.
*/}}
{{- define "prowlarr.configXml" -}}
<Config>
  <BindAddress>{{ .Values.secretConfig.bindAddress }}</BindAddress>
  <Port>{{ .Values.secretConfig.port }}</Port>
  <SslPort>{{ .Values.secretConfig.sslPort }}</SslPort>
  <EnableSsl>{{ .Values.secretConfig.enableSsl }}</EnableSsl>
  <LaunchBrowser>{{ .Values.secretConfig.launchBrowser }}</LaunchBrowser>
  {{- /* Handle apiKey potentially coming from a secret */}}
  <ApiKey>{{ default .Values.secretConfig.apiKey (include "prowlarr.secretValue" (dict "secretRef" .Values.secretConfig.apiKeySecretRef "context" $)) }}</ApiKey>
  <AuthenticationMethod>{{ .Values.secretConfig.authenticationMethod }}</AuthenticationMethod>
  <AuthenticationRequired>{{ .Values.secretConfig.authenticationRequired }}</AuthenticationRequired>
  <Branch>{{ .Values.secretConfig.branch }}</Branch>
  <LogLevel>{{ .Values.secretConfig.logLevel }}</LogLevel>
  <SslCertPath>{{ .Values.secretConfig.sslCertPath }}</SslCertPath>
  {{- /* Handle sslCertPassword potentially coming from a secret */}}
  <SslCertPassword>{{ default .Values.secretConfig.sslCertPassword (include "prowlarr.secretValue" (dict "secretRef" .Values.secretConfig.sslCertPasswordSecretRef "context" $)) }}</SslCertPassword>
  <UrlBase>{{ .Values.secretConfig.urlBase }}</UrlBase>
  <InstanceName>{{ .Values.secretConfig.instanceName }}</InstanceName>
  <UpdateMechanism>{{ .Values.secretConfig.updateMechanism }}</UpdateMechanism>

  {{- /* Postgres settings are now handled by the CloudnativePG integration when enabled */}}
  {{- if and (not .Values.cloudnativepg.enabled) .Values.secretConfig.postgres.enabled }}
  <PostgresUser>{{ .Values.secretConfig.postgres.user }}</PostgresUser>
  {{- /* Handle postgres password potentially coming from a secret */}}
  <PostgresPassword>{{ default .Values.secretConfig.postgres.password (include "prowlarr.secretValue" (dict "secretRef" .Values.secretConfig.postgres.passwordSecretRef "context" $)) }}</PostgresPassword>
  <PostgresHost>{{ .Values.secretConfig.postgres.host }}</PostgresHost>
  <PostgresPort>{{ .Values.secretConfig.postgres.port }}</PostgresPort>
  <PostgresMainDb>{{ .Values.secretConfig.postgres.mainDb }}</PostgresMainDb>
  <PostgresLogDb>{{ .Values.secretConfig.postgres.logDb }}</PostgresLogDb>
  {{- end }}
</Config>
{{- end -}}

{{/*
Helper to retrieve a value from a referenced secret.
Usage: {{ include "prowlarr.secretValue" (dict "secretRef" .Values.someSecretRef "context" $) }}
*/}}
{{- define "prowlarr.secretValue" -}}
{{- $secretRef := .secretRef -}}
{{- $context := .context -}}
{{- if and $secretRef $secretRef.name $secretRef.key -}}
{{- $secret := lookup "v1" "Secret" $context.Release.Namespace $secretRef.name -}}
{{- if $secret -}}
{{- index $secret.data $secretRef.key | b64dec -}}
{{- else -}}
{{- /* Use a placeholder value when the secret doesn't exist during template rendering */ -}}
{{- printf "PLACEHOLDER_WILL_BE_REPLACED_BY_INIT_CONTAINER" -}}
{{- end -}}
{{- else -}}
{{- /* Return empty string if secretRef is not properly defined */ -}}
{{- "" -}}
{{- end -}}
{{- end -}}
