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
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "autopulse.statefulset.apiVersion" -}}
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
