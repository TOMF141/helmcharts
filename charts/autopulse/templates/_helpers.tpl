{{/*
Expand the name of the chart.
*/}}
{{- define "autopulse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "autopulse.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "autopulse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "autopulse.labels" -}}
helm.sh/chart: {{ include "autopulse.chart" . }}
{{ include "autopulse.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "autopulse.selectorLabels" -}}
app.kubernetes.io/name: {{ include "autopulse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "autopulse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "autopulse.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "autopulse.deployment.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "autopulse.ingress.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1" }}
networking.k8s.io/v1
{{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" }}
networking.k8s.io/v1beta1
{{- else -}}
extensions/v1beta1
{{- end -}}
{{- end }}

{{/*
Return if ingress is stable.
*/}}
{{- define "autopulse.ingress.isStable" -}}
{{- .Capabilities.APIVersions.Has "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return if ingress supports pathType.
*/}}
{{- define "autopulse.ingress.supportsPathType" -}}
{{- or (eq (include "autopulse.ingress.isStable" .) "true") (.Capabilities.APIVersions.Has "networking.k8s.io/v1beta1") -}}
{{- end -}}

{{/*
Get the name for the config secret.
If a name is specified in values, use that. Otherwise, generate one.
*/}}
{{- define "autopulse.config.secretName" -}}
{{- if .Values.config.secretName }}
{{- .Values.config.secretName }}
{{- else }}
{{- include "autopulse.fullname" . }}-config
{{- end }}
{{- end }}

{{/*
Get the external PostgreSQL service host.
This value must be provided in externalDatabase.host.
*/}}
{{- define "autopulse.database.host" -}}
{{- required "externalDatabase.host must be set" .Values.externalDatabase.host }}
{{- end }}

{{/*
Get the external PostgreSQL service port.
This value must be provided in externalDatabase.port.
*/}}
{{- define "autopulse.database.port" -}}
{{- required "externalDatabase.port must be set" .Values.externalDatabase.port }}
{{- end }}

{{/*
Get the external PostgreSQL username.
This value must be provided in externalDatabase.username.
*/}}
{{- define "autopulse.database.username" -}}
{{- required "externalDatabase.username must be set" .Values.externalDatabase.username }}
{{- end }}

{{/*
Get the external PostgreSQL database name.
This value must be provided in externalDatabase.database.
*/}}
{{- define "autopulse.database.database" -}}
{{- required "externalDatabase.database must be set" .Values.externalDatabase.database }}
{{- end }}

{{/*
Get the external PostgreSQL password secret name.
This value must be provided in externalDatabase.existingPasswordSecret.
*/}}
{{- define "autopulse.database.passwordSecretName" -}}
{{- required "externalDatabase.existingPasswordSecret must be set" .Values.externalDatabase.existingPasswordSecret }}
{{- end }}

{{/*
Get the external PostgreSQL password secret key.
This value must be provided in externalDatabase.passwordSecretKey.
*/}}
{{- define "autopulse.database.passwordSecretKey" -}}
{{- required "externalDatabase.passwordSecretKey must be set" .Values.externalDatabase.passwordSecretKey }}
{{- end }}

{{/*
Define database environment variables based on configuration method.
*/}}
{{- define "autopulse.databaseEnvVars" -}}
{{- if .Values.externalDatabase.existingConnectionStringSecret -}}
# Method 3: Use full connection string from existing secret
- name: AUTOPULSE__APP__DATABASE_URL
  valueFrom:
    secretKeyRef:
      name: {{ required "externalDatabase.existingConnectionStringSecret must be set for Method 3" .Values.externalDatabase.existingConnectionStringSecret }}
      key: {{ required "externalDatabase.connectionStringSecretKey must be set for Method 3" .Values.externalDatabase.connectionStringSecretKey }}
{{- else if .Values.externalDatabase.existingConnectionDetailsSecret -}}
# Method 4: Use individual components from existing secret
- name: AUTOPULSE__APP__DATABASE_URL
  # Construct the URL from env vars populated below
  value: "postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)"
# Map secret keys to expected env var names for the connection string
- name: DB_HOST
  valueFrom:
    secretKeyRef:
      name: {{ required "externalDatabase.existingConnectionDetailsSecret must be set for Method 4" .Values.externalDatabase.existingConnectionDetailsSecret }}
      key: {{ required "externalDatabase.hostSecretKey must be set for Method 4" .Values.externalDatabase.hostSecretKey }}
- name: DB_PORT
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingConnectionDetailsSecret }}
      key: {{ required "externalDatabase.portSecretKey must be set for Method 4" .Values.externalDatabase.portSecretKey }}
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingConnectionDetailsSecret }}
      key: {{ required "externalDatabase.usernameSecretKey must be set for Method 4" .Values.externalDatabase.usernameSecretKey }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingConnectionDetailsSecret }}
      key: {{ required "externalDatabase.passwordSecretKey must be set for Method 4" .Values.externalDatabase.passwordSecretKey }}
- name: DB_NAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingConnectionDetailsSecret }}
      key: {{ required "externalDatabase.databaseSecretKey must be set for Method 4" .Values.externalDatabase.databaseSecretKey }}
{{- else -}}
# Method 2 (Default): Use external DB details from values.yaml, password from existing secret
# This is the fallback if neither Method 3 nor Method 4 is configured.
- name: AUTOPULSE__APP__DATABASE_URL
  value: "postgres://{{ include "autopulse.database.username" . }}:$(POSTGRES_PASSWORD)@{{ include "autopulse.database.host" . }}:{{ include "autopulse.database.port" . }}/{{ include "autopulse.database.database" . }}"
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      # Uses helpers which now always require externalDatabase values
      name: {{ include "autopulse.database.passwordSecretName" . }}
      key: {{ include "autopulse.database.passwordSecretKey" . }}
{{- end }}
{{- end -}}

{{/*
Placeholder: Define application-specific helpers here if needed.
Example: Helper to render a config file based on appConfig/secretConfig.
*/}}
{{/*
{{- define "autopulse.configfile" -}}
# Example config file content rendered by Helm chart {{ .Chart.Name }}-{{ .Chart.Version }}
# setting1: {{ .Values.appConfig.setting1 | quote }}
# sensitive_setting: {{ .Values.secretConfig.sensitive_setting | quote }}
{{- end -}}
*/}}
