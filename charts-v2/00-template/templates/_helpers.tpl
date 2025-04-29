{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "template.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "template.fullname" -}}
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
{{- define "template.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "template.labels" -}}
helm.sh/chart: {{ include "template.chart" . }}
{{ include "template.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "template.selectorLabels" -}}
app.kubernetes.io/name: {{ include "template.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "template.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "template.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "template.deployment.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "template.statefulset.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for daemonset.
*/}}
{{- define "template.daemonset.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "template.ingress.apiVersion" -}}
{{- if and .Values.ingress.enabled (semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion) -}}
networking.k8s.io/v1
{{- else if and .Values.ingress.enabled (semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion) -}}
networking.k8s.io/v1beta1
{{- else -}}
extensions/v1beta1
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for HorizontalPodAutoscaler.
*/}}
{{- define "template.hpa.apiVersion" -}}
{{- if semverCompare ">=1.23-0" .Capabilities.KubeVersion.GitVersion -}}
autoscaling/v2
{{- else -}}
autoscaling/v2beta2
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for HTTPRoute (Gateway API).
*/}}
{{- define "template.gatewayapi.httproute.apiVersion" -}}
{{- default "gateway.networking.k8s.io/v1beta1" .Values.gatewayApi.httpRoute.apiVersionOverride -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for Gateway (Gateway API).
*/}}
{{/*
{{- define "template.gatewayapi.gateway.apiVersion" -}}
{{- default "gateway.networking.k8s.io/v1beta1" .Values.gatewayApi.gateway.apiVersionOverride -}}
{{- end -}}
*/}}

{{/*
Common annotations
*/}}
{{- define "template.annotations" -}}
{{- with .Values.commonAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end }}
