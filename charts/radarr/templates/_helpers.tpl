{{- define "radarr.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "radarr.labels" -}}
{{- if .Values.labels }}
{{ toYaml .Values.labels | nindent 4 }}
{{- end }}
{{- end }}

{{- define "radarr.configXml" -}}
<Config>
  <BindAddress>{{ .Values.configXml.bindAddress }}</BindAddress>
  <Port>{{ .Values.configXml.port }}</Port>
  <SslPort>{{ .Values.configXml.sslPort }}</SslPort>
  <EnableSsl>{{ .Values.configXml.enableSsl }}</EnableSsl>
  <LaunchBrowser>{{ .Values.configXml.launchBrowser }}</LaunchBrowser>
  <ApiKey>{{ .Values.configXml.apiKey }}</ApiKey>
  <AuthenticationMethod>{{ .Values.configXml.authenticationMethod }}</AuthenticationMethod>
  <AuthenticationRequired>{{ .Values.configXml.authenticationRequired }}</AuthenticationRequired>
  <Branch>{{ .Values.configXml.branch }}</Branch>
  <LogLevel>{{ .Values.configXml.logLevel }}</LogLevel>
  <SslCertPath>{{ .Values.configXml.sslCertPath }}</SslCertPath>
  <SslCertPassword>{{ .Values.configXml.sslCertPassword }}</SslCertPassword>
  <UrlBase>{{ .Values.configXml.urlBase }}</UrlBase>
  <InstanceName>{{ .Values.configXml.instanceName }}</InstanceName>
  <UpdateMechanism>{{ .Values.configXml.updateMechanism }}</UpdateMechanism>

  {{- if .Values.configXml.postgres.enabled }}
  <PostgresUser>{{ .Values.configXml.postgres.user }}</PostgresUser>
  <PostgresPassword>{{ .Values.configXml.postgres.password }}</PostgresPassword>
  <PostgresHost>{{ .Values.configXml.postgres.host }}</PostgresHost>
  <PostgresPort>{{ .Values.configXml.postgres.port }}</PostgresPort>
  <PostgresMainDb>{{ .Values.configXml.postgres.mainDb }}</PostgresMainDb>
  <PostgresLogDb>{{ .Values.configXml.postgres.logDb }}</PostgresLogDb>
  {{- end }}
</Config>
{{- end }}
