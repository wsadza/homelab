{{/* vim: set filetype=mustache: */}}

{{/*
============================================
  Common Lables 
============================================
*/}}

{{/*
--------------------------------------------
Kubernetes standard labels
{{ include "common.labels.standard" (dict "customLabels" .Values.commonLabels "context" $) -}}
--------------------------------------------
*/}}
{{- define "common.labels.standard" -}}
{{- if and (hasKey . "customLabels") (hasKey . "context") -}}
{{- $default := dict "app.kubernetes.io/name" (include "common.names.name" .context) "helm.sh/chart" (include "common.names.chart" .context) "app.kubernetes.io/instance" .context.Release.Name "app.kubernetes.io/managed-by" .context.Release.Service -}}
{{- with .context.Chart.AppVersion -}}
{{- $_ := set $default "app.kubernetes.io/version" . -}}
{{- end -}}
{{ template "common.tplvalues.merge" (dict "values" (list .customLabels $default) "context" .context) }}
{{- else -}}
app.kubernetes.io/name: {{ include "common.names.name" . }}
helm.sh/chart: {{ include "common.names.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Chart.AppVersion }}
app.kubernetes.io/version: {{ . | replace "+" "_" | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
--------------------------------------------
Labels used on immutable fields such as deploy.spec.selector.matchLabels or svc.spec.selector
{{ include "common.labels.matchLabels" (dict "customLabels" .Values.podLabels "context" $) -}}

We don't want to loop over custom labels appending them to the selector
since it's very likely that it will break deployments, services, etc.
However, it's important to overwrite the standard labels if the user
overwrote them on metadata.labels fields.
--------------------------------------------
*/}}
{{- define "common.labels.matchLabels" -}}
{{- if and (hasKey . "customLabels") (hasKey . "context") -}}
{{ merge (pick (include "common.tplvalues.render" (dict "value" .customLabels "context" .context) | fromYaml) "app.kubernetes.io/name" "app.kubernetes.io/instance") (dict "app.kubernetes.io/name" (include "common.names.name" .context) "app.kubernetes.io/instance" .context.Release.Name ) | toYaml }}
{{- else -}}
app.kubernetes.io/name: {{ include "common.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- end -}}

{{/*
============================================
  Common Names
============================================
*/}}

{{/*
--------------------------------------------
Expand the name of the chart.
--------------------------------------------
*/}}
{{- define "common.names.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
--------------------------------------------
Create chart name and version as used by the chart label.
--------------------------------------------
*/}}
{{- define "common.names.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
--------------------------------------------
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
--------------------------------------------
*/}}
{{- define "common.names.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $releaseName := regexReplaceAll "(-?[^a-z\\d\\-])+-?" (lower .Release.Name) "-" -}}
{{- if contains $name $releaseName -}}
{{- $releaseName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $releaseName $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
--------------------------------------------
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
--------------------------------------------
*/}}
{{- define "common.names.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
============================================
  Application - Extras 
============================================
*/}}

{{/*
--------------------------------------------
Generate replication hosts list for LDAP_REPLICATION_HOSTS
--------------------------------------------
*/}}
{{- define "extras.openldap.replicationHosts" -}}
{{- $replicas := int .Values.openldap.configuration.replication.replicas }}
{{- $namespace := default (include "common.names.namespace" . ) .Values.openldap.namespace }}
{{- $fullname := include "common.names.fullname" . }}
{{- $hosts := list }}
{{- range $i := until $replicas }}
{{- $hosts = append $hosts (printf "ldap://%s-%d.%s-headless.%s.svc.cluster.local" $fullname $i $fullname $namespace) }}
{{- end }}
{{- printf "#PYTHON2BASH:%s" (toJson $hosts) }}
{{- end }}


{{/*
--------------------------------------------
Return OpenLDAP replica count.
--------------------------------------------
*/}}
{{- define "extras.openldap.replicas" -}}
{{- if .Values.openldap.configuration.replication.enabled -}}
{{- .Values.openldap.configuration.replication.replicas | int -}}
{{- else -}}
1
{{- end -}}
{{- end -}}

{{/*
--------------------------------------------
Define Secrets Helpers
--------------------------------------------
*/}}
{{- define "openldap.secretName" -}}
{{- if .Values.openldap.configuration.existingSecret.enabled -}}
{{- .Values.openldap.configuration.existingSecret.name -}}
{{- else -}}
{{- printf "%s-secrets" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "openldap.secretKey.adminPassword" -}}
{{- if .Values.openldap.configuration.existingSecret.enabled -}}
{{- .Values.openldap.configuration.existingSecret.keys.adminPassword -}}
{{- else -}}
LDAP_ADMIN_PASSWORD
{{- end -}}
{{- end -}}

{{- define "openldap.secretKey.configPassword" -}}
{{- if .Values.openldap.configuration.existingSecret.enabled -}}
{{- .Values.openldap.configuration.existingSecret.keys.configPassword -}}
{{- else -}}
LDAP_CONFIG_PASSWORD
{{- end -}}
{{- end -}}
